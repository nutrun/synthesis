module Synthesis
  class Formatter
    def initialize(out)
      @out = out
    end
    
    def report_tested_expectations
      ExpectationRecord.tested_expectations.each { |e| @out.puts e.to_report }
    end
    
    def report_untested_expectations
      ExpectationRecord.untested_expectations.each { |e| @out.puts e.to_report }
    end
    
    class << self
      def load(out)
        @formatter.new(out)
      end
    
      def inherited(subclass)
        @formatter = subclass
      end
    end
  end
end