module FairyWingThrowdown
  JSON_FILE = File.expand_path(File.dirname(__FILE__) + "/../data.json")

  class << self
    def json_string
      File.read JSON_FILE
    end

    def canonical_ruby
      JSON.parse json_string
    end
  end
end
