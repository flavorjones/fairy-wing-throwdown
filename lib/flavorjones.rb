require 'nokogiri'
require 'active_support/core_ext'

module Flavorjones
  class << self
    def xml_string
      # use activesupport's standard xml serialization format.
      FairyWingThrowdown.canonical_ruby.to_xml(:dasherize => false)
    end
  end

  class XML
    def initialize xml
      @xml = xml
    end

    def transform_via_active_support
      Hash.from_xml(@xml)["hash"]
    end

    def transform_via_dom
      result = {}
      doc = Nokogiri::XML::Document.parse(@xml) {|c| c.noblanks }
      result["product"] = doc.xpath("/hash/product").text
      result["messages"] = doc.xpath("/hash/messages/message").map do |message|
        message.children.inject({}) do |hash, child|
          if child.children.length == 1 && child.children.first.text?
            hash[child.name] = child.text
          else
            hash[child.name] = child.children.inject({}) do |sub_hash, sub_child|
              sub_hash[sub_child.name] = case sub_child["type"]
                                         when "integer" then sub_child.text.to_i
                                         when "float" then Float(sub_child.text)
                                         else sub_child.text
                                         end
              sub_hash
            end
          end
          hash
        end
      end
      result
    end

    def transform_via_sax
    end

    private

    def traverse node, &block
      block.call(self)
      children.each{|j| j.traverse(&block) }
    end
  end
end
