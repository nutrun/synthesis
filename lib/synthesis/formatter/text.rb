module Synthesis
  class TextFormatter < Formatter
    include Logging
    
    def initialize
      Expectation::Expectation.send(:include, ExpectationReportFormat::Text)
    end
    
    def format_success
      log; log "Verified #{ExpectationRecord.expectations.size} expectations"
      log "SUCCESS."
    end

    def format_failure
      log; log "Tested Expectations: "
      ExpectationRecord.tested_expectations.each { |e| log e.to_report }
      log; log "Untested Expectations: "
      ExpectationRecord.untested_expectations.each { |e| log e.to_report }
      log "Ignoring: #{ExpectationRecord.ignored.to_a * ', '}"
      log; log "FAILED."
    end
  end
  
  module ExpectationReportFormat
    module Text
      def to_report
        "(#{return_value_type}) " +
        "#{receiver_repr}.#{@method}" + 
        "(#{@args.map { |arg| arg.class } * ', '}) " + 
        "in #{@track}"
      end
    end
  end
end