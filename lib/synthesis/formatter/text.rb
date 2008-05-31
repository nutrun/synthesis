module Synthesis
  class TextFormatter < Formatter
    include Logging
    
    def initialize
      Expectation::Instance.send(:include, ExpectationReportFormat::Text)
    end

    def format_failure
      ExpectationRecord.tested_expectations.each { |e| log e.to_report }
      ExpectationRecord.untested_expectations.each { |e| log e.to_report }
      log "Ignoring: #{ExpectationRecord.ignored.to_a * ', '}"
      log; log "FAILED."
    end
    
    def format_success
      log; log "Verified #{ExpectationRecord.expectations.size} expectations"
      log "SUCCESS."
    end
  end
end