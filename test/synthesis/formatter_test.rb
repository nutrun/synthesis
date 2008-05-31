require File.dirname(__FILE__) + "/helper"

module Synthesis
  class FormatterTest < Test::Unit::TestCase
    def test_loads_text_formatter
      require File.dirname(__FILE__) + "/../../lib/synthesis/formatter/text"
      assert_kind_of(Synthesis::TextFormatter, Formatter.load)
    end
    
    def test_loads_dot_formatter
      require File.dirname(__FILE__) + "/../../lib/synthesis/formatter/dot"
      assert_kind_of(Synthesis::DotFormatter, Formatter.load)
    end
  end
end