module Synthesis
  module Formatter
    def self.for(format, expectation_record)
      require "synthesis/formatter/#{format}_formatter"
      const_get("#{format.to_s.capitalize}Formatter".intern).new(expectation_record)
    end
  end
end