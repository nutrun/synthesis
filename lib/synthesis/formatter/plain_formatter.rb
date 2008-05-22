module Synthesis
  module Formatter
    class PlainFormatter
      include Logging

      def initialize(expectation_record)
        @expectation_record = expectation_record
      end
      
      def format_failure
        @expectation_record.print_tested_expectations
        @expectation_record.print_untested_expectations
        @expectation_record.print_ignored
        log; log "FAILED."
      end
      
      def format_success
        log; log "Verified #{@expectation_record.expectations.size} expectations"
        log "SUCCESS."
      end
    end
  end
end