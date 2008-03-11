module Synthesis
  class ExpectationRecord
    class << self
      include Logging
      
      def add_expectation(receiver, method, track, args = [])
        unless ignore? receiver
          expectation = Expectation.new(receiver, method, track, args)
          expectations << expectation
          expectation
        end
      end
      
      def ignore(*args)
        ignored.merge args
      end
      
      def expectations
        @expectations ||= []
        @expectations.uniq!
        @expectations
      end
      
      def ignored
        @ignored ||= Set.new
      end
      
      def [](matcher)
        expectations.detect { |e| e == matcher } || Expectation::NilExpectation.new
      end
      
      def record_invocations
        expectations.each { |e| e.record_invocations }
      end
      
      def tested_expectations
        expectations.select { |e| e.invoked? }
      end
      
      def untested_expectations
        expectations.select { |e| !e.invoked? }
      end      
      
      def print_tested_expectations
        log; log "Tested Expectations: "
        tested_expectations.each { |e| log e }
      end
      
      def print_untested_expectations
        log; log "Untested Expectations: "
        untested_expectations.each { |e| log e }
      end
      
      def print_ignored
        log; log "Ignoring: #{ignored.to_a * ', '}" 
      end
      
      private
      
      def ignore?(obj)
        ignored.include?(obj.class) || ignored.include?(obj) || obj.is_a?(MOCK_OBJECT)
      end  
    end
  end
end
