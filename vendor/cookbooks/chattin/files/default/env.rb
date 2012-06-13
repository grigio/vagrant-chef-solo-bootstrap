#!/usr/bin/env ruby
require 'yaml'
require 'shellwords'

# Usage:
#   env.rb set foo bar
#   env.rb export
#   env.rb inline

yaml_path = File.expand_path('../env.yaml', __FILE__)

if File.exist?(yaml_path)
  yaml = YAML.load_file(yaml_path) rescue {}
  yaml = {} unless yaml.kind_of?(Hash)
else
  yaml = {}
end

if ARGV[0] == "set" && ARGV.size == 3
  var = ARGV[1]
  val = ARGV[2]
  yaml[var] = val

  File.open(yaml_path, 'w') { |f| f.write(yaml.to_yaml) }
elsif ARGV[0] == "export" && ARGV.size == 1
  export_list = yaml.map do |k,v|
    "export #{k.shellescape}=#{v.shellescape}"
  end.join("\n")

  puts export_list
elsif ARGV[0] == "inline" && ARGV.size == 1
  inline_list = yaml.map do |k,v|
    "#{k.shellescape}=#{v.shellescape}"
  end.join(" ")

  puts inline_list
else
  STDERR.puts "invalid use!"
  exit 1
end
