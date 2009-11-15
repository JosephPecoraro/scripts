#!/usr/bin/env ruby
# Author: Joseph Pecoraro
# Date: Wednesday, September 30, 2009
# Description: Grep with Ruby Regex

# Error
if ARGV.size == 0
  puts "rgrep: Forgot Regex" 
  exit 1
end

# Run the Regex on the File
regex = Regexp.new(ARGV[0])
STDIN.readlines.each do |line|
  puts line if line.match(regex)
end
