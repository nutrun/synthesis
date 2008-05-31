module Synthesis
  class Reporter
    def report
      formatter = Formatter.load
      if ExpectationRecord.untested_expectations.any?
        formatter.format_failure
        return -1
      end
      formatter.format_success
      0
    end
  end
end