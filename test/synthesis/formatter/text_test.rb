require File.dirname(__FILE__) + "/../helper"

module Synthesis
  class TextFormatterTest < Test::Unit::TestCase
    def test_includes_text_format_in_expectation
      load File.dirname(__FILE__) + "/../../../lib/synthesis/formatter/text.rb"
      Synthesis::TextFormatter.new
      ancestors = Synthesis::Expectation::Expectation.ancestors
      assert(ancestors.include?(Synthesis::ExpectationReportFormat::Text))
    end
  end
end