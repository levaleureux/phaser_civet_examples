require 'thor'

class Build < Thor
  desc "last_date", "Show last modification date of this file"
  def last_date
    puts File.mtime(__FILE__)
  end
end