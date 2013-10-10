#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'optparse'
require 'active_resource'

$config = Hash[classname: 'Ann', verbose: false]

opts = OptionParser::new
opts.on("-c", "--class CLASSNAME") { |classname|
  $config[:classname] = classname
}
opts.on("-v", "--verbose") {
  $config[:verbose] = true
}
opts.on("-h", "--help") {
  STDERR.puts "Usage: register.rb [-c, --class CLASSNAME] [filename]"
  STDERR.puts
  STDERR.puts "   Register objects of class CLASSNAME using data in the given file."
  STDERR.puts "   If CLASSNAME is omitted, Ann is used as default class."
  STDERR.puts
  exit 0
}
opts.parse!(ARGV)


def myclass
  @myclass ||= generate_class($config[:classname])
end

def generate_class(name)
  klass = Class.new(ActiveResource::Base) do
    self.site = 'http://localhost:3000'
    self.include_root_in_json = true
  end

  puts "Class: #{name.singularize.classify}" if $config[:verbose]
  Object.const_set(name.singularize.classify, klass)
end

require 'yaml'
items = YAML.load(ARGF)

begin
  items.each do |item|
    myclass.create(item)
  end
rescue Errno::ECONNREFUSED
  STDERR.puts "Error: Connection refused"
end
