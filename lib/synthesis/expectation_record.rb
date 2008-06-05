module Synthesis
  class ExpectationRecord
    class << self
      include Logging

      def add_expectation(receiver, method, track, args = [])
        unless ignore?(receiver)
          expectation = Expectation.new(receiver, method, track, args)
          expectations << expectation
          expectation
        end
      end

      def ignore(*args)
        ignored.merge(args)
      end

      def expectations
        # Using an Array instead of a Set because the +Expectation+ instance 
        # is not complete when first added. A Set would result to possible duplicates.
        # obj.expects(:method).with(:args)
        # the +Expectation+ will be added when obj.expects(:method) is called
        # the +Expectation+ arguments will be added when .with(:args) is called
        @expectations ||= []
      end

      def ignored
        @ignored ||= Set.new
      end

      def [](matcher)
        # Using a hash for faster look up of expectations 
        # when recording invocations
        expectations_with_return[matcher] || expectations_without_return[matcher] || Expectation::NilExpectation.new
      end

      def record_invocations
        expectations.map! { |e| e.explode }
        expectations.flatten!
        expectations.uniq!
        expectations.each do |e|
          e.record_invocations
          if e.return_values_defined?
            expectations_with_return[e] = e 
          else
            expectations_without_return[e] = e
          end
        end
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
      def expectations_with_return
        @expectations_with_return ||= {}
      end

      def expectations_without_return
        @expectations_without_return ||= {}
      end

      def ignore?(obj)
        ignored.include?(obj.class) ||
        (obj.is_a?(Class) && ignored.include?(obj)) ||
        (obj.is_a?(Module) && ignored.include?(obj)) ||
        obj.is_a?(MOCK_OBJECT)
      end

      def reset!
        @expectations_with_return, @expectations_without_return, @expectations, @ignored = nil
      end
    end
  end
end
