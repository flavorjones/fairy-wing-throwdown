require 'nokogiri'
require 'active_support/core_ext'

module Flavorjones
  class << self
    def xml_string
      # use activesupport's standard xml serialization format.
      FairyWingThrowdown.canonical_ruby.to_xml(:dasherize => false)
    end

    def format_value string, type
      case type
      when "integer" then string.to_i
      when "float" then Float(string)
      else string
      end
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
              sub_hash[sub_child.name] = Flavorjones.format_value sub_child.text, sub_child["type"]
              sub_hash
            end
          end
          hash
        end
      end
      result
    end

    def transform_via_sax
      sax_doc = Flavorjones::SaxDocument.new
      parser = Nokogiri::XML::SAX::Parser.new sax_doc
      parser.parse @xml
      sax_doc.hash
    end

    def transform_via_reader
      reader = Nokogiri::XML::Reader @xml

      # reimplement sax parser here. *headdesk*
      hash = {"messages" => []}
      where_am_i = nil
      message_attr_name = nil
      message_attr_type = nil

      reader.each do |node|
        case node.node_type
        when Nokogiri::XML::Reader::TYPE_ELEMENT
          if where_am_i == :message_values
            attribute = node.attributes.first
            message_attr_name = node.name.dup # see https://github.com/tenderlove/nokogiri/issues/439
            message_attr_type = attribute && attribute.last
          else
            case node.name
            when "product"
              where_am_i = :product
            when "message"
              hash["messages"] << {"values" => {}}
              where_am_i = :message
            when "id"
              where_am_i = :message_id
            when "values"
              where_am_i = :message_values
            else
            end
          end

        when Nokogiri::XML::Reader::TYPE_END_ELEMENT
          if node.name == "values"
            where_am_i = "message"
          elsif node.name == "product" || node.name == "message"
            where_am_i = nil
          end

        when Nokogiri::XML::Reader::TYPE_TEXT
          string = node.value
          next if string.blank?
          case where_am_i
          when :message_values
            hash["messages"].last["values"][message_attr_name] = Flavorjones.format_value string, message_attr_type
          when :message_id
            hash["messages"].last["id"] = string
          when :product
            hash["product"] = string
          end

        end
      end
      hash
    end

    private

    def traverse node, &block
      block.call(self)
      children.each{|j| j.traverse(&block) }
    end
  end

  class SaxDocument < Nokogiri::XML::SAX::Document
    attr_accessor :hash

    def initialize
      @hash = {"messages" => []}
      @where_am_i = nil
      @message_attr_name = nil
    end

    def start_element_namespace name, attributes = [], *args
      if @where_am_i == :message_values
        @message_attr_name = name
        @message_attr_type = attributes.first && attributes.first.value
      else
        case name
        when "product"
          @where_am_i = :product
        when "message"
          @hash["messages"] << {"values" => {}}
          @where_am_i = :message
        when "id"
          @where_am_i = :message_id
        when "values"
          @where_am_i = :message_values
        else
        end
      end
    end

    def end_element_namespace name, *args
      if name == "values"
        @where_am_i = "message"
      elsif name == "product" || name == "message"
        @where_am_i = nil
      end
    end

    def characters string
      return if string.blank?
      case @where_am_i
      when :message_values
        @hash["messages"].last["values"][@message_attr_name] = Flavorjones.format_value string, @message_attr_type
      when :message_id
        @hash["messages"].last["id"] = string
      when :product
        @hash["product"] = string
      end
    end
  end
end
