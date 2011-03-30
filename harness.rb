#! /usr/bin/env ruby

require 'rubygems'
require 'json/ext'
require 'nokogiri'
require 'benchmark'

json = File.read "data.json"
ruby = JSON.parse json

if ARGV[0] == "to_xml"
  require 'active_support/core_ext'
  puts "transforming to xml ..."
  File.open("data.xml", "w") { |f| f.write ruby.to_xml }

elsif ARGV[0] == "benchmark"
  puts "benchmarking ..."
  xml = File.read "data.xml"
  n = 1_000

  Benchmark.bmbm do |benchmark|
    benchmark.report("json") { n.times { JSON.parse json                   } }
    benchmark.report("xml")  { n.times { Nokogiri::XML::Document.parse xml } }
  end

elsif ARGV[0] == "test_equality"

else
  puts "i need an argument"
  exit 1
end
