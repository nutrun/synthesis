require File.dirname(__FILE__) + "/helper"

module Synthesis
  class FormatterTest < Test::Unit::TestCase
    def test_loads_plain_formatter
      require File.dirname(__FILE__) + "/../../lib/synthesis/formatter/plain_formatter"
      assert_kind_of(Synthesis::PlainFormatter, Formatter.load)
    end
    
    def test_loads_dot_formatter
      require File.dirname(__FILE__) + "/../../lib/synthesis/formatter/dot_formatter"
      assert_kind_of(Synthesis::DotFormatter, Formatter.load)
    end
  end
end