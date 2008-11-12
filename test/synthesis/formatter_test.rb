require File.dirname(__FILE__) + "/helper"

module Synthesis
  class FormatterTest < Test::Unit::TestCase
    def test_loads_text_formatter
      load File.dirname(__FILE__) + "/../../lib/synthesis/formatter/text.rb"
      assert_kind_of(Synthesis::TextFormatter, Formatter.load(anything))
    end
    
    def test_loads_dot_formatter
      load File.dirname(__FILE__) + "/../../lib/synthesis/formatter/dot.rb"
      assert_kind_of(Synthesis::DotFormatter, Formatter.load(anything))
    end
  end
end