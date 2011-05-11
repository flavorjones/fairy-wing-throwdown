#! /usr/bin/env ruby

require 'benchmark'

$: << File.expand_path("./lib")
require "fairy_wing_throwdown"
require 'flavorjones'

puts
puts "---------- #{RUBY_DESCRIPTION} ----------"
puts Nokogiri::VERSION_INFO.to_yaml.gsub(/^/,'         | ')
puts

json           = FairyWingThrowdown.json_string
canonical_ruby = FairyWingThrowdown.canonical_ruby

xml = Flavorjones.xml_string
n = 1_000

if ARGV[0] == "perftools"
  puts "perftools ..."
  require 'perftools'
  PerfTools::CpuProfiler.start("sax_profile") do
    n.times { Flavorjones::XML.new(xml).transform_via_sax }
  end

else
  puts "benchmarking ..."
  Benchmark.bmbm(20) do |benchmark|
    benchmark.report("json") do
      n.times { JSON.parse json }
    end
    # benchmark.report("xml (activesupport)") do
    #   n.times { Flavorjones::XML.new(xml).transform_via_active_support }
    # end
    benchmark.report("xml (noko-dom)") do
      n.times { Flavorjones::XML.new(xml).transform_via_dom }
    end
    benchmark.report("xml (noko-sax)") do
      n.times { Flavorjones::XML.new(xml).transform_via_sax }
    end
    benchmark.report("xml (noko-reader)") do
      n.times { Flavorjones::XML.new(xml).transform_via_reader }
    end
  end
end
