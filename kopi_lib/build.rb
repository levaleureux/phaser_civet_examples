require 'thor'
require 'yaml'
require 'fileutils'
require 'set'

class Build < Thor
  desc "examples", "Compile Civet examples and generate Jekyll pages"
  def examples
    jekyll_dir = "jekyll"
    civet_dir = "civet_examples"
    build_dir = "#{jekyll_dir}/js/builded_examples"
    examples_dir = "#{jekyll_dir}/_examples"
    data_dir = "#{jekyll_dir}/_data"

    # Create build directories
    FileUtils.mkdir_p(build_dir)
    FileUtils.mkdir_p(examples_dir)
    FileUtils.mkdir_p("#{jekyll_dir}/_categories")
    FileUtils.mkdir_p(data_dir)

    # Initialize data files
    File.open("#{data_dir}/examples.yml", "w") { |f| f.puts "examples:" }
    File.open("#{data_dir}/categories.yml", "w") { |f| f.puts "categories:" }
    seen_categories = Set.new

    # Find all .civet files
    Dir.glob("#{civet_dir}/**/*.civet").each do |file|
      # Get category and slug
      category = File.basename(File.dirname(file))
      slug = File.basename(file, ".civet")

      # Compile
      output_dir = "#{build_dir}/#{category}"
      FileUtils.mkdir_p(output_dir)
      output_file = "#{output_dir}/#{slug}.js"
      if system("civet -c #{file} -o #{output_file} 2>/dev/null")
        puts "Compiled #{file}"
      else
        puts "Failed to compile #{file}, skipping"
        next
      end

      # Create example page
      md_content = <<~MD
        ---
        layout: example
        title: "Example #{slug}"
        category: #{category}
        slug: #{slug}
        ---
      MD
      File.write("#{examples_dir}/#{slug}.md", md_content)

      # Add to data
      File.open("#{data_dir}/examples.yml", "a") do |f|
        f.puts "  - slug: #{slug}"
        f.puts "    category: #{category}"
        f.puts "    title: \"Example #{slug}\""
      end

      # Track categories
      unless seen_categories.include?(category)
        seen_categories.add(category)
        File.open("#{data_dir}/categories.yml", "a") do |f|
          f.puts "  - slug: #{category}"
          f.puts "    name: \"#{category}\""
        end

        # Create category page
        cat_md_content = <<~MD
          ---
          layout: category
          title: "#{category} Examples"
          category: #{category}
          ---
        MD
        File.write("#{jekyll_dir}/_categories/#{category}.md", cat_md_content)
      end
    end

    puts "Build complete."
  end

  desc "last_date", "Show last modification date of this file"
  def last_date
    puts File.mtime(__FILE__)
  end
end