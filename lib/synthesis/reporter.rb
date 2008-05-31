module Synthesis
  class Reporter
    def self.report
      formatter = Formatter.load
      if ExpectationRecord.has_untested_expectations?
        formatter.format_failure
        return -1
      end
      formatter.format_success
      0
    end
  end
end