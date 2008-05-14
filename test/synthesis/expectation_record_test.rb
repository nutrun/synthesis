require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationRecordTest < Test::Unit::TestCase
    def teardown
      ExpectationRecord.send(:reset!)
    end

    def test_adds_expectation
      ExpectationRecord.add_expectation Object.new, :to_s, :track
      assert_equal(1, ExpectationRecord.expectations.size)
    end

    def test_watches_expectation_invocations
      c = Class.new { def foo; end }
      ExpectationRecord.add_expectation(c.new, :foo, :track)
      ExpectationRecord.record_invocations
      a = c.new
      MethodInvocationWatcher.expects(:invoked).with(a, :foo, [], [nil])
      a.foo
    end

    def test_finds_expectation
      expected = ExpectationRecord.add_expectation(Object.new, :foo, :track)
      expected.add_return_values(20)
      matcher = Expectation.new(Object.new, :foo, :track, [], [20])
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
      ExpectationRecord.ignore(Hash)
      ExpectationRecord.add_expectation(Hash, :foo, :track)
      assert ExpectationRecord.expectations.empty?
    end
    
    def test_returns_added_expectation_on_add
      expected = Expectation.new(Hash, :foo, :track, [], [:return_val])
      actual = ExpectationRecord.add_expectation(Hash, :foo, :track)
      actual.add_return_values(:return_val)
      assert_equal(expected, actual)
    end
    
    def test_uniqs_expectations_before_recording_invocations
      ExpectationRecord.add_expectation(Hash, :foo, :track)
      ExpectationRecord.add_expectation(Hash, :foo, :track)
      assert_equal(2, ExpectationRecord.expectations.size)
      ExpectationRecord.record_invocations
      assert_equal(1, ExpectationRecord.expectations.size)
    end
    
    def test_flattens_expectations_before_recording_invocations
      expectation = ExpectationRecord.add_expectation(Hash, :foo, :track)
      expectation.add_return_values(1, "str", "sym")
      ExpectationRecord.record_invocations
      ExpectationRecord.expectations.each { |val| assert(!val.is_a?(Array)) }
    end
  end
end
