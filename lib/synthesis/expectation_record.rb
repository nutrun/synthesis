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
      
      def remove(expectation)
        expectations.delete(expectation)
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
        expectations_with_return_values[matcher] ||
        expectations_without_return_values[matcher] ||
        Expectation::NilExpectation.new
      end

      def record_invocations
        expectations.map! { |e| e.explode }
        expectations.flatten!
        expectations.uniq!
        expectations.each do |e|
          e.record_invocations
          if e.return_values_defined?
            expectations_with_return_values[e] = e 
          else
            expectations_without_return_values[e] = e
          end
        end
      end

      def tested_expectations
        expectations.select { |e| e.invoked? }
      end

      def untested_expectations
        expectations.select { |e| !e.invoked? }
      end
      
      def has_untested_expectations?
        untested_expectations.any?
      end

      private
      def expectations_with_return_values
        @expectations_with_return_values ||= {}
      end

      def expectations_without_return_values
        @expectations_without_return_values ||= {}
      end

      def ignore?(obj)
        ignored.include?(obj.class) ||
        ignored.include?(obj.class.to_s) ||
        (obj.is_a?(Class) && ignored.include?(obj)) ||
        (obj.is_a?(Class) && ignored.include?(obj.to_s)) ||
        (obj.is_a?(Module) && ignored.include?(obj)) ||
        (obj.is_a?(Module) && ignored.include?(obj.to_s)) ||
        obj.is_a?(MOCK_OBJECT)
      end

      def reset!
        @expectations_with_return_values = nil
        @expectations_without_return_values = nil
        @expectations, @ignored = nil
      end
    end
  end
end
