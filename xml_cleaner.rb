#!/usr/bin/env ruby
# Start Date: March 16, 2008
# Current Version: 1.0
# Author: Joseph Pecoraro
# Contact: joepeck02@gmail.com
# Decription: "tidys" an xml file, removes "id" elements

# For each command line provided filename
# 1. Get entire data
# 2. Put into an XML Document
# 3. Remove <id>texts</id>
# 4. Print to STDOUT with 2 space indents for tags
# 5. Follow with a newline
require 'rexml/document'
ARGV.each do |filename|
  doc = REXML::Document.new( File.new(filename).read )
  doc.root.get_elements('//id').each { |e| e.text = '--removed--' }
  doc.write($stdout,2)
  puts
end
