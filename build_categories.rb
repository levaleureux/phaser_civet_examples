#!/usr/bin/env ruby

require 'thor'

class BuildCategories < Thor
  desc "build", "Build categories from civet examples"
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

    puts "Categories built successfully."
  end
end

BuildCategories.start(ARGV)