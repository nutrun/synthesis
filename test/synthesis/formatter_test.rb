require File.dirname(__FILE__) + "/helper"

module Synthesis
  class DummyFormatter < Formatter
  end
  
  class FormatterTest < Test::Unit::TestCase
    def test_loads_appropriate_formatter_dinamically
      Formatter.instance_variable_set(:@formatter, DummyFormatter)
      Formatter.load(anything)
      assert_kind_of(DummyFormatter, Formatter.load(anything))
    end
  end
end