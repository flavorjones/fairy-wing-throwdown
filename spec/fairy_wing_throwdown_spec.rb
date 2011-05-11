require 'rspec'
require File.dirname(__FILE__) + "/../lib/fairy_wing_throwdown"
require File.dirname(__FILE__) + "/../lib/flavorjones"

#
#  comparing floats is hard. let's go shopping.
#
#  no, but seriously. this makes it possible to compare the entire
#  data structure with a single #== call.
#
class Float
  def == other
    (self - other).abs < 0.000001
  end
end

describe Flavorjones::XML do
  before do
    @xml = Flavorjones.xml_string
  end

  describe ".transform_via_active_support" do
    it "matches the objective ruby data structure" do
      Flavorjones::XML.new(@xml).transform_via_active_support.should == FairyWingThrowdown.canonical_ruby
    end
  end

  describe ".transform_via_dom" do
    it "matches the objective ruby data structure" do
      Flavorjones::XML.new(@xml).transform_via_dom.should == FairyWingThrowdown.canonical_ruby
    end
  end

  describe ".transform_via_sax" do
    it "matches the objective ruby data structure" do
      Flavorjones::XML.new(@xml).transform_via_sax.should == FairyWingThrowdown.canonical_ruby
    end
  end

  describe ".transform_via_reader" do
    it "matches the objective ruby data structure" do
      Flavorjones::XML.new(@xml).transform_via_reader.should == FairyWingThrowdown.canonical_ruby
    end
  end
end
