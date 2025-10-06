require 'thor'
require 'yaml'
require 'fileutils'

class Generate < Thor
  no_commands do
    def process_yaml_for_examples(yaml_file, examples_dir, full_slug)
      data = YAML.load_file(yaml_file)
      examples = data['examples'] || []

      if examples.any?
        examples.each do |example|
          id = example['url_js'].split('/').last.to_i
          id_padded = id.to_s.rjust(3, '0')
          name_slug = example['name'].downcase.gsub(/[^a-z0-9]+/, '_').gsub(/^_+|_+$/, '')
          subdir = "#{id_padded}_#{name_slug}"

          md_dir = "#{examples_dir}/#{full_slug}"
          FileUtils.mkdir_p(md_dir)

          md_file = "#{md_dir}/#{subdir}.md"
          js_path = "/assets/examples/#{full_slug}/examples/#{subdir}/original.js"

          content = <<~MD
---
layout: example
category: #{full_slug}
slug: #{subdir}
name: #{example['name']}
js_path: #{js_path}
---
Example content.
          MD

          File.write(md_file, content)
        end
      end

      # Recurse for sub-categories
      cat_dir = File.dirname(yaml_file)
      Dir.glob("#{cat_dir}/*").each do |sub|
        next unless File.directory?(sub)
        sub_slug = File.basename(sub)
        sub_yaml = "#{sub}/#{sub_slug}.yml"
        sub_full_slug = "#{full_slug}-#{sub_slug}"
        process_yaml_for_examples(sub_yaml, examples_dir, sub_full_slug) if File.exist?(sub_yaml)
      end
    end

    def process_category(yaml_file, categories_dir, full_slug, parent_slug)
      data = YAML.load_file(yaml_file)
      name = data['name']

      examples = data['examples'] || []
      is_leaf = examples.any?

      sub_categories = []

      cat_dir = File.dirname(yaml_file)
      Dir.glob("#{cat_dir}/*").each do |sub|
        next unless File.directory?(sub)
        sub_yaml = "#{sub}/#{File.basename(sub)}.yml"
        if File.exist?(sub_yaml)
          sub_data = YAML.load_file(sub_yaml)
          sub_categories << { 'slug' => "#{full_slug}-#{File.basename(sub)}", 'name' => sub_data['name'], 'sub_slug' => File.basename(sub) }
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

      content = front_matter.to_yaml + "\n---\n"

      File.write(md_file, content)

      # Recurse for sub-categories
      sub_categories.each do |sub_cat|
        sub_slug = sub_cat['slug'].split('-').last
        sub_yaml = "#{cat_dir}/#{sub_slug}/#{sub_slug}.yml"
        process_category(sub_yaml, categories_dir, sub_cat['slug'], full_slug) if File.exist?(sub_yaml)
      end
    end
  end

  desc "example_pages", "Generate Jekyll pages for examples"
  def example_pages
    examples_dir = 'civet_examples'
    output_dir = 'jekyll/_examples'

    Dir.glob("#{examples_dir}/*").each do |cat_dir|
      next unless File.directory?(cat_dir)
      category = File.basename(cat_dir)
      yaml_file = "#{cat_dir}/#{category}.yml"
      process_yaml_for_examples(yaml_file, output_dir, category) if File.exist?(yaml_file)
    end

    puts "Example pages generated successfully."
  end

  desc "category_pages", "Generate Jekyll category pages for structure"
  def category_pages
    examples_dir = 'civet_examples'
    categories_dir = 'jekyll/_categories'

    Dir.glob("#{examples_dir}/*").each do |cat_dir|
      next unless File.directory?(cat_dir)
      category = File.basename(cat_dir)
      yaml_file = "#{cat_dir}/#{category}.yml"
      process_category(yaml_file, categories_dir, category, nil) if File.exist?(yaml_file)
    end

    puts "Category pages generated successfully."
  end

  desc "last_date", "Show last modification date of this file"
  def last_date
    puts File.mtime(__FILE__)
  end
end