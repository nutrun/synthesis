require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationReportFormatTest < Test::Unit::TestCase
    def test_instance_expectation_text_report_format
      expectation = Expectation.new(Array.new, :foo, :track, [:arg], [:retval])
      expectation.extend(ExpectationReportFormat::Text)
      assert_equal("(Symbol) Array.new.foo(Symbol) in track", expectation.to_report)
    end
    
    def test_singleton_expectation_text_report_format
      expectation = Expectation.new(Array, :foo, :track, [:arg], [:retval])
      expectation.extend(ExpectationReportFormat::Text)
      assert_equal("(Symbol) Array.foo(Symbol) in track", expectation.to_report)
    end
    
    def test_expectation_dot_report_format
      expectation = Expectation.new(Array, :foo, :track, [:arg], [:retval])
      expectation.extend(ExpectationReportFormat::Dot)
      filename = File.dirname(__FILE__) + "/../../lib/synthesis/logging.rb"
      test_subject = ['dontcare', "#{filename}:14:`log'"]
      expectation.test_subject = test_subject
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