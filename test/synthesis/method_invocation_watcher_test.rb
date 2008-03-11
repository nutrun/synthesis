require File.dirname(__FILE__) + "/helper"

module Synthesis
  class MethodInvocationWatcherTest < Test::Unit::TestCase
    def test_marks_expectation_invoked
      ExpectationRecord.add_expectation(Hash, :to_s, [])
      MethodInvocationWatcher.invoked(Hash, :to_s, [])
      expectation = ExpectationRecord.expectations.to_a.first
      assert expectation.invoked?
    end
  end
end
