require File.dirname(__FILE__) + "/../helper"
load File.dirname(__FILE__) + "/../../../lib/synthesis/formatter/dot.rb"

module Synthesis
  class DotFormatterTest < Test::Unit::TestCase
    def test_includes_text_format_in_expectation
      Synthesis::DotFormatter.new(anything)
      ancestors = Synthesis::Expectation::Expectation.ancestors
      assert(ancestors.include?(Synthesis::ExpectationReportFormat::Dot))
    end
    
    def test_expectation_dot_report_format
      expectation = Expectation.new(Array, :foo, :track, [:arg], [:retval])
      expectation.extend(ExpectationReportFormat::Dot)
      expectation.add_test_subject([['skip1'],['skip2'],['skip3'], [Synthesis::Logging, :method, 'filename', 14, 'binding', :Ruby]])
      expected = "  \"Synthesis::Logging\" -> \"Array\" [ label = \"(Symbol) foo(Symbol)\" ];"
      assert_equal(expected, expectation.to_report)
    end
    
    def test_expectation_dot_report_format_when_test_subject_unknown
      expectation = Expectation.new(Array, :foo, :track, [:arg], [:retval])
      expectation.extend(ExpectationReportFormat::Dot)
      expected = "  \"?\" -> \"Array\" [ label = \"(Symbol) foo(Symbol)\" ];"
      assert_equal(expected, expectation.to_report)
    end
  end
end