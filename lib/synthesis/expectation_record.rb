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
        # Using an Array instead of a Set because the +Expectation+ instance 
        # is not complete when first added. A Set would result to possible duplicates.
        # obj.expects(:method).with(:args)
        # the +Expectation+ will be added when obj.expects(:method) is called
        # the +Expectation+ arguments will be added when .with(:args) is called
        @expectations ||= []
        @expectations.uniq!
        @expectations
      end

      def ignored
        @ignored ||= Set.new
      end

      def [](matcher)
        # Using a hash when for faster look up of expectations 
        # when recording invocations
        expectations_hash[matcher] || Expectation::NilExpectation.new
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
      def expectations_hash
        @expectations_hash ||= expectations.inject({}) do |hash, expectation|
          hash[expectation] = expectation
          hash
        end
      end

      def ignore?(obj)
        ignored.include?(obj.class) || ignored.include?(obj) || obj.is_a?(MOCK_OBJECT)
      end

      def reset!
        @expectations_hash, @expectations, @ignored = nil
      end
    end
  end
end
