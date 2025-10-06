require 'thor'
require 'yaml'
require 'nokogiri'
require 'net/http'
require 'fileutils'

class Scrap < Thor
  desc "v2", "Build v2 structure from Phaser examples URL"
  def v2
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

  desc "examples YAML_FILE", "Scrape examples from YAML file and download assets"
  def examples(yaml_file)
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

  desc "last_date", "Show last modification date of this file"
  def last_date
    puts File.mtime(__FILE__)
  end
end