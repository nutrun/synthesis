module Synthesis
  class Reporter
    class << self
      def report(format)
        formatter = Formatter.for(format, ExpectationRecord)
        if failed?
          formatter.format_failure
          return -1
        end
        formatter.format_success
        0
      end

      def failed?
        ExpectationRecord.untested_expectations.any?
      end
    end
  end
end