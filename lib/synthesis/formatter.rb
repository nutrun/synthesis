module Synthesis
  class Formatter
    def report_tested_expectations
      ExpectationRecord.tested_expectations.each { |e| puts e.to_report }
    end
    
    def report_untested_expectations
      ExpectationRecord.untested_expectations.each { |e| puts e.to_report }
    end
    
    class << self
      def load
        @formatter.new
      end
    
      def inherited(subclass)
        @formatter = subclass
      end
    end
  end
end