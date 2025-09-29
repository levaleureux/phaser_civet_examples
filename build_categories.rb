#!/usr/bin/env ruby

require 'thor'
require 'yaml'
require 'nokogiri'
require 'net/http'

class BuildCategories < Thor
  desc "build", "Build categories and examples from civet examples"
  def build
    jekyll_dir = "jekyll"
    civet_dir = "civet_examples"
    data_dir = "#{jekyll_dir}/_data"
    categories_dir = "#{jekyll_dir}/_categories"

    Dir.mkdir(data_dir) unless Dir.exist?(data_dir)
    Dir.mkdir(categories_dir) unless Dir.exist?(categories_dir)

    categories = {}

    Dir.glob("#{civet_dir}/**/*.civet").each do |file|
      category = File.basename(File.dirname(file))
      categories[category] = true
    end

    File.open("#{data_dir}/categories.yml", "w") do |f|
      f.puts "categories:"
      categories.keys.sort.each do |cat|
        f.puts "  - slug: #{cat}"
        f.puts "    name: \"#{cat}\""
      end
    end

    categories.keys.each do |cat|
      File.open("#{categories_dir}/#{cat}.md", "w") do |f|
        f.puts "---"
        f.puts "layout: category"
        f.puts "title: \"#{cat} Examples\""
        f.puts "category: #{cat}"
        f.puts "---"
      end
    end

    # Build examples
    File.open("#{data_dir}/examples.yml", "w") do |f|
      f.puts "examples:"
      Dir.glob("#{civet_dir}/**/*.civet").each do |file|
        category = File.basename(File.dirname(file))
        slug = File.basename(file, '.civet')
        f.puts "  - slug: #{slug}"
        f.puts "    category: #{category}"
        f.puts "    title: \"Example #{slug}\""
      end
    end

    puts "Categories and examples built successfully."
  end

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

    puts "V2 structure built successfully."
  end

  desc "grid CATEGORY", "Generate examples grid HTML for a category"
  def grid(category)
    data_dir = "jekyll/_data"
    examples_file = "#{data_dir}/examples.yml"

    if !File.exist?(examples_file)
      puts "Examples data not found. Run 'build' first."
      return
    end

    examples = YAML.load_file(examples_file)['examples']
    category_examples = examples.select { |e| e['category'] == category }

    html = '<div class="examples-grid">'
    category_examples.each do |example|
      html += <<~HTML
        <div class="example-item">
            <div class="category-image"></div>
            <div class="category-content">
                <h4><a href="/examples/#{example['slug']}.html">#{example['title']}</a></h4>
                <p>Phaser example in CivetScript</p>
            </div>
        </div>
      HTML
    end
    html += '</div>'

    puts html
  end
end

BuildCategories.start(ARGV)