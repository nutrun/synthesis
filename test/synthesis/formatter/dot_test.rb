require File.dirname(__FILE__) + "/../helper"

module Synthesis
  class DotFormatterTest < Test::Unit::TestCase
    def test_includes_text_format_in_expectation
      load File.dirname(__FILE__) + "/../../../lib/synthesis/formatter/dot.rb"
      Synthesis::DotFormatter.new
      ancestors = Synthesis::Expectation::Expectation.ancestors
      assert(ancestors.include?(Synthesis::ExpectationReportFormat::Dot))
    end
  end
end