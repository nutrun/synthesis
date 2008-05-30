module Synthesis
  class PlainFormatter < Formatter
    include Logging

    def format_failure
      ExpectationRecord.print_tested_expectations
      ExpectationRecord.print_untested_expectations
      ExpectationRecord.print_ignored
      log; log "FAILED."
    end
    
    def format_success
      log; log "Verified #{ExpectationRecord.expectations.size} expectations"
      log "SUCCESS."
    end
  end
end