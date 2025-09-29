#!/usr/bin/env ruby

require 'thor'
require 'yaml'
require 'nokogiri'
require 'net/http'
require 'fileutils'

class BuildCategories < Thor

  desc "build_v2", "Build v2 structure from Phaser examples URL"
  def build_v2
    def process_category(url, parent_dir, slug)
      uri = URI(url)
      response = Net::HTTP.get(uri)
      doc = Nokogiri::HTML(response)
      name = doc.at_css('.examples_title a:last')&.text&.strip || slug.split('-').map(&:capitalize).join(' ')
      cat_dir = "#{parent_dir}/#{slug}"
      Dir.mkdir(cat_dir) unless Dir.exist?(cat_dir)

      subfolders = doc.css('.examples_folders_folder').reject { |f| f['class']&.include?('folder_back') }
      if subfolders.any?
        # Has subcategories
        examples = []
        subfolders.each do |sub|
          sub_name = sub.at_css('.examples_folders_folder_name')&.text&.strip
          next unless sub_name
          next if sub_name.downcase == 'back' # Skip back links
          sub_slug = sub_name.downcase.gsub(' ', '-')
          sub_url = sub.at_css('a')['href']
          process_category(sub_url, cat_dir, sub_slug)
        end
      else
        # Leaf category with examples
        examples = []
        doc.css('.examples_folders_example').each do |ex|
          ex_link = ex.at_css('a')
          if ex_link
            ex_name = ex.at_css('.examples_folders_example_name').text.strip
            ex_url = ex_link['href']
            ex_image = ex.at_css('img')['src'] rescue "/assets/images/#{slug}/#{ex_name.downcase.gsub(/[^a-z0-9]+/, '-')}.png"
            examples << {
              'name' => ex_name,
              'url_js' => ex_url,
              'url_image' => ex_image
            }
          end
        end
      end

      yaml = { 'name' => name, 'examples' => examples }
      File.write("#{cat_dir}/#{slug}.yml", yaml.to_yaml)
    end

    url = 'https://phaser.io/examples/v3.85.0'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    doc = Nokogiri::HTML(response)
    categories = doc.css('.examples_folders_folder')

    v2_dir = 'civet_examples_v2'
    Dir.mkdir(v2_dir) unless Dir.exist?(v2_dir)

    categories.each do |cat|
      name = cat.at_css('.examples_folders_folder_name')&.text&.strip
      next unless name
      slug = name.downcase.gsub(' ', '-')
      cat_url = cat.at_css('a')['href']
      process_category(cat_url, v2_dir, slug)
    end

    # Generate categories.yml for Jekyll
    jekyll_data_dir = 'jekyll/_data'
    Dir.mkdir(jekyll_data_dir) unless Dir.exist?(jekyll_data_dir)
    File.open("#{jekyll_data_dir}/categories.yml", "w") do |f|
      f.puts "categories:"
      categories.each do |cat|
        name = cat.at_css('.examples_folders_folder_name')&.text&.strip
        next unless name
        slug = name.downcase.gsub(' ', '-')
        f.puts "  - slug: #{slug}"
        f.puts "    name: \"#{name}\""
      end
    end

    puts "V2 structure built successfully."
  end



  desc "generate_example_pages", "Generate Jekyll pages for v2 examples"
  def generate_example_pages
    v2_dir = 'civet_examples_v2'
    examples_dir = 'jekyll/_examples'

    Dir.glob("#{v2_dir}/*").each do |cat_dir|
      next unless File.directory?(cat_dir)
      category = File.basename(cat_dir)
      yaml_file = "#{cat_dir}/#{category}.yml"
      next unless File.exist?(yaml_file)

      data = YAML.load_file(yaml_file)
      examples = data['examples'] || []

      examples.each do |example|
        id = example['url_js'].split('/').last.to_i
        id_padded = id.to_s.rjust(3, '0')
        name_slug = example['name'].downcase.gsub(/[^a-z0-9]+/, '_').gsub(/^_+|_+$/, '')
        subdir = "#{id_padded}_#{name_slug}"

        md_dir = "#{examples_dir}/#{category}"
        FileUtils.mkdir_p(md_dir)

        md_file = "#{md_dir}/#{subdir}.md"
        js_path = "/assets/examples/#{category}/examples/#{subdir}/original.js"

        content = <<~MD
---
layout: example
category: #{category}
slug: #{subdir}
name: #{example['name']}
js_path: #{js_path}
---
        MD

        File.write(md_file, content)
      end
    end

    puts "Example pages generated successfully."
  end

  desc "generate_category_pages", "Generate Jekyll category pages for v2 structure"
  def generate_category_pages
    v2_dir = 'civet_examples_v2'
    categories_dir = 'jekyll/_categories'

    def process_category(yaml_file, categories_dir, parent_slug = nil)
      data = YAML.load_file(yaml_file)
      name = data['name']
      slug = File.basename(File.dirname(yaml_file))
      full_slug = parent_slug ? "#{parent_slug}-#{slug}" : slug

      examples = data['examples'] || []
      is_leaf = examples.any?

      sub_categories = []
      cat_dir = File.dirname(yaml_file)
      Dir.glob("#{cat_dir}/*").each do |sub|
        next unless File.directory?(sub)
        sub_yaml = "#{sub}/#{File.basename(sub)}.yml"
        if File.exist?(sub_yaml)
          sub_data = YAML.load_file(sub_yaml)
          sub_categories << { 'slug' => "#{full_slug}-#{File.basename(sub)}", 'name' => sub_data['name'] }
        end
      end

      # Generate MD file
      md_file = "#{categories_dir}/#{full_slug}.md"
      FileUtils.mkdir_p(categories_dir)

      front_matter = {
        'layout' => 'category',
        'title' => "#{name} Examples",
        'category' => full_slug,
        'is_leaf' => is_leaf,
        'sub_categories' => sub_categories,
        'parent' => parent_slug
      }

      content = front_matter.to_yaml + "---\n"

      File.write(md_file, content)

      # Recurse for sub-categories
      sub_categories.each do |sub_cat|
        sub_slug = sub_cat['slug'].split('-').last
        sub_yaml = "#{cat_dir}/#{sub_slug}/#{sub_slug}.yml"
        process_category(sub_yaml, categories_dir, full_slug) if File.exist?(sub_yaml)
      end
    end

    Dir.glob("#{v2_dir}/*").each do |cat_dir|
      next unless File.directory?(cat_dir)
      category = File.basename(cat_dir)
      yaml_file = "#{cat_dir}/#{category}.yml"
      next unless File.exist?(yaml_file)
      process_category(yaml_file, categories_dir)
    end

    puts "Category pages generated successfully."
  end

  desc "scrape_examples YAML_FILE", "Scrape examples from YAML file and download assets"
  def scrape_examples(yaml_file)
    unless File.exist?(yaml_file)
      puts "YAML file not found: #{yaml_file}"
      return
    end

    data = YAML.load_file(yaml_file)
    examples = data['examples'] || []

    examples_dir = "#{File.dirname(yaml_file)}/examples"
    FileUtils.mkdir_p(examples_dir)

    examples.each do |example|
      id = example['url_js'].split('/').last.to_i
      id_padded = id.to_s.rjust(3, '0')
      name_underscore = example['name'].downcase.gsub(/[^a-z0-9]+/, '_').gsub(/^_+|_+$/, '')
      folder_name = "#{id_padded}_#{name_underscore}"
      folder_path = "#{examples_dir}/#{folder_name}"
      FileUtils.mkdir_p(folder_path)

      # Download image
      begin
        uri_image = URI(example['url_image'])
        response_image = Net::HTTP.get_response(uri_image)
        if response_image.is_a?(Net::HTTPSuccess)
          File.write("#{folder_path}/thumb.png", response_image.body)
        else
          warn "Failed to download image for #{example['name']}: #{response_image.code}"
        end
      rescue => e
        warn "Error downloading image for #{example['name']}: #{e.message}"
      end

      # Download and extract JS
      begin
        category = File.basename(File.dirname(yaml_file))
        slug = example['name'].downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
        url = "https://phaser.io/examples/v3.85.0/#{category}/view/#{slug}"
        uri_js = URI(url)
        response_js = Net::HTTP.get_response(uri_js)
        if response_js.is_a?(Net::HTTPSuccess)
          doc = Nokogiri::HTML(response_js.body)
          code_tag = doc.at_css('pre.example_code_codefile code')
          if code_tag
            File.write("#{folder_path}/original.js", code_tag.text)
          else
            warn "Failed to extract JS for #{example['name']}: no code tag found"
          end
        else
          warn "Failed to download JS page for #{example['name']}: #{response_js.code}"
        end
      rescue => e
        warn "Error downloading/extracting JS for #{example['name']}: #{e.message}"
      end
    end

    puts "Scraped examples successfully."
  end
end

BuildCategories.start(ARGV)