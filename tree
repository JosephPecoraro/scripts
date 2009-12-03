#!/usr/bin/env ruby
# Author: Joseph Pecoraro
# Date: Sunday, June 7, 2009
# Description: Tree Listing of a Directory
# Delim and Spacer work best when they are the same length

class DirTree

  def initialize(directory, options)
    @dir        = directory            || Dir.pwd
    @delim      = options[:delim]      || '+-'
    @spacer     = options[:spacer]     || '| '
    @hidden     = options[:hidden]     || false
    @onlydirs   = options[:dirs]       || false
    @limit      = options[:limit]      || 0
    @extensions = options[:extensions] || []

    # Sanitize extensions to include dots if they don't
    @extensions.map! { |e| e =~ /^\./ ? e : ".#{e}" }
  end

  def print
    pwd = Dir.pwd
    Dir.chdir(@dir)
    _print
    Dir.chdir(pwd)
  end

private

  def valid_depth_count(depth, filename)
    i = 0
    depth.each do |lvl|
      unless filename.sub!(/^#{lvl}\//,'').nil?
        i += 1
      else
        break
      end
    end
    i
  end

  def _print
    depth = []
    count_since_change = 0
    prefix = [' '*@delim.length]
    spacer_length = @spacer.length
    list = @hidden ? Dir.glob('**/*', File::FNM_DOTMATCH).delete_if { |x| x=~/\.(\.|DS_Store)?$/ } : Dir['**/*']
    ignore_extensions = @extensions.empty?

    puts "#{@delim}#{File.basename(@dir)}"
    list.each_with_index do |filename, index|

      # Local States
      is_dir = File.directory? filename
      within_limit = (@limit <= 0 || count_since_change < @limit)
      valid_extension = is_dir || ignore_extensions || @extensions.member?(File.extname(filename))
      should_print = is_dir || (!@onlydirs && valid_extension)

      # Skip
      next if !valid_extension

      # Clean the Prefix - Chop characters off and update change count
      size = valid_depth_count(depth, filename)
      count_since_change += (is_dir ? 0 : 1)
      count_since_change = 0 if (size != depth.size)
      while size != depth.size
        depth.pop; prefix.pop
      end

      # Output this file
      if should_print
        if is_dir || within_limit
          suffix = is_dir ? '/' : ''
          puts "#{prefix.join}#{@delim}#{filename}#{suffix}"
        elsif count_since_change == @limit+1
          puts "#{prefix.join}#{' '*@delim.length}..."
        end
      end

      # If this is a directory it may affect future entries
      if is_dir
        another = false
        dir_prefix = depth.join('/')
        index.upto(list.size-1) do |n|
          str = list[n]
          if str =~ /^#{dir_prefix}/
            str = str.sub(/^#{dir_prefix}\/?/,'')
            if str !~ /^#{filename}/
              another = true
              break
            end
          end
        end

        # Output No Leading Pipe if nothing is on the same level
        prefix << (another ? @spacer : ' '*spacer_length)
        depth  << filename
        count_since_change = 0
      end

    end
  end

end


# When Run as a Script
if $0 == __FILE__
  trap("INT") { puts "\nInterrupted."; exit }
  require 'optparse'
  tree_options = { :delim => '+--', :spacer => '|  ' }
  OptionParser.new do |opts|
    opts.banner =  "usage: tree [options] [dir ...]"
    opts.on('-a', '--all',        'Show hidden files')       { tree_options[:hidden] = true }
    opts.on('-d', '--dir',        'Show only directories')   { tree_options[:dirs]   = true }
    opts.on('-l', '--limit NUM',  'Limit Big Listings')      { |l| tree_options[:limit] = l.to_i }
    opts.on('-e', '--ext   LIST', 'Whitelist of extensions') { |l| tree_options[:extensions] = l.split(/,/) }
    opts.on('-h', '--help',       'Show this help.')         { puts opts; exit }
  end.parse!

  ARGV << '.' if ARGV.empty?
  ARGV.each do |dir|
    DirTree.new(File.expand_path(dir), tree_options).print
    puts
  end
end
