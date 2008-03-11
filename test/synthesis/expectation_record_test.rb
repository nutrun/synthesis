require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationRecordTest < Test::Unit::TestCase
    def teardown
      ExpectationRecord.expectations.clear
      ExpectationRecord.ignored.clear
    end

    def test_adds_expectation
      ExpectationRecord.add_expectation Object.new, :to_s, :track
      assert_equal(1, ExpectationRecord.expectations.size)
    end

    def test_watches_expectation_invocations
      c = Class.new { def foo; end }
      ExpectationRecord.add_expectation c.new, :foo, :track
      ExpectationRecord.record_invocations
      a = c.new
      MethodInvocationWatcher.expects(:invoked).with(a, :foo, [])
      a.foo
    end

    def test_finds_expectation
      ExpectationRecord.add_expectation Object.new, :foo, :track
      expected = ExpectationRecord.expectations.to_a[0]
      matcher = Expectation.new Object.new, :foo, :track
      actual = ExpectationRecord[matcher]
      assert_equal(expected, actual)
    end

    def test_returns_nil_expectation_on_no_expectation_found
      ExpectationRecord.add_expectation Object.new, :foo, :track
      matcher = Expectation.new Object.new, :bar, :track
      actual_instance = ExpectationRecord[matcher]
      assert_kind_of Expectation::NilExpectation, actual_instance
    end

    def test_does_not_add_expectation_for_ignored_class
      ExpectationRecord.ignore Hash
      ExpectationRecord.add_expectation Hash, :foo, :track
      assert ExpectationRecord.expectations.empty?
    end
    
    def test_returns_added_expectation_on_add
      expected = Expectation.new Hash, :foo, :track
      actual = ExpectationRecord.add_expectation Hash, :foo, :track
      assert_equal expected, actual
    end
  end
end
