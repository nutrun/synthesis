require File.dirname(__FILE__) + "/../helper"
load File.dirname(__FILE__) + "/../../../lib/synthesis/formatter/text.rb"

module Synthesis
  class TextFormatterTest < Test::Unit::TestCase
    def test_includes_text_format_in_expectation
      Synthesis::TextFormatter.new
      ancestors = Synthesis::Expectation::Expectation.ancestors
      assert(ancestors.include?(Synthesis::ExpectationReportFormat::Text))
    end
    
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
  end
end