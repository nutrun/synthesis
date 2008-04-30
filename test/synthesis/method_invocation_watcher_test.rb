require File.dirname(__FILE__) + "/helper"

module Synthesis
  class MethodInvocationWatcherTest < Test::Unit::TestCase
    def teardown
      ExpectationRecord.send(:reset!)
    end

    def test_marks_expectation_invoked
      ExpectationRecord.add_expectation(Hash, :to_s, :track, []).add_return_values(1)
      MethodInvocationWatcher.invoked(Hash, :to_s, [], [1])
      expectation = ExpectationRecord.expectations.to_a.first
      assert expectation.invoked?
    end
  end
end
