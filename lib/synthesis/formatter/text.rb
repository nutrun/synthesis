module Synthesis
  class TextFormatter < Formatter
    include Logging
    
    def initialize(out)
      super
      Expectation::Expectation.send(:include, ExpectationReportFormat::Text)
    end
    
    def format_success
      @out.puts "[Synthesis] "
      @out.puts "[Synthesis] Verified #{ExpectationRecord.expectations.size} expectations"
      @out.puts "[Synthesis] SUCCESS."
    end

    def format_failure
      @out.puts "[Synthesis] "
      @out.puts "[Synthesis] Tested Expectations: "
      report_tested_expectations
      @out.puts "[Synthesis] "
      @out.puts "[Synthesis] Untested Expectations: "
      report_untested_expectations
      @out.puts "[Synthesis] Ignoring: #{ExpectationRecord.ignored.to_a * ', '}"
      @out.puts "[Synthesis] "
      @out.puts "[Synthesis] FAILED."
    end
  end
  
  module ExpectationReportFormat
    module Text
      def to_report
        "(#{return_value_type}) #{receiver_repr}.#{@method}" +
        "(#{arg_types * ', '}) in #{@track}"
      end
    end
  end
end