require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationRecordTest < Test::Unit::TestCase
    def teardown
      ExpectationRecord.send(:reset!)
    end

    def test_adds_expectation
      ExpectationRecord.add_expectation(Object.new, :to_s, :track)
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
      c = Class.new { def foo; end }
      expected = ExpectationRecord.add_expectation(c.new, :foo, :track)
      expected.add_return_values(20)
      ExpectationRecord.record_invocations
      matcher = Expectation.new(c.new, :foo, :track, [], [20])
      actual = ExpectationRecord[matcher]
      assert_equal(expected, actual)
    end

    def test_returns_nil_expectation_on_no_expectation_found
      ExpectationRecord.add_expectation(Object.new, :foo, :track)
      matcher = Expectation.new(Object.new, :bar, :track)
      actual_instance = ExpectationRecord[matcher]
      assert_kind_of(Expectation::NilExpectation, actual_instance)
    end

    def test_does_not_add_expectation_for_ignored_class
      ExpectationRecord.ignore(Hash)
      ExpectationRecord.add_expectation(Hash, :foo, :track)
      assert(ExpectationRecord.expectations.empty?)
    end
    
    def test_does_not_add_expectation_for_ignored_object
      ExpectationRecord.ignore(Hash)
      ExpectationRecord.add_expectation(Hash.new, :foo, :track)
      assert(ExpectationRecord.expectations.empty?)
    end
    
    def test_does_not_add_expectation_for_ignored_module
      ExpectationRecord.ignore(Enumerable)
      ExpectationRecord.add_expectation(Enumerable, :foo, :track)
      assert(ExpectationRecord.expectations.empty?)
    end

    def test_does_not_add_expectation_for_ignored_class_as_string
      ExpectationRecord.ignore('Hash')
      ExpectationRecord.add_expectation(Hash, :foo, :track)
      assert(ExpectationRecord.expectations.empty?)
    end
    
    def test_does_not_add_expectation_for_ignored_object_as_string
      ExpectationRecord.ignore('Hash')
      ExpectationRecord.add_expectation(Hash.new, :foo, :track)
      assert(ExpectationRecord.expectations.empty?)
    end
    
    def test_does_not_add_expectation_for_ignored_module_as_string
      ExpectationRecord.ignore('Enumerable')
      ExpectationRecord.add_expectation(Enumerable, :foo, :track)
      assert(ExpectationRecord.expectations.empty?)
    end
    
    def test_returns_added_expectation_on_add
      expected = Expectation.new(Hash, :foo, :track, [], [:return_val])
      actual = ExpectationRecord.add_expectation(Hash, :foo, :track)
      actual.add_return_values(:return_val)
      assert_equal(expected, actual)
    end
    
    def test_uniqs_expectations_before_recording_invocations
      c = Class.new { def foo; end }
      ExpectationRecord.add_expectation(c, :foo, :track)
      ExpectationRecord.add_expectation(c, :foo, :track)
      assert_equal(2, ExpectationRecord.expectations.size)
      ExpectationRecord.record_invocations
      assert_equal(1, ExpectationRecord.expectations.size)
    end
    
    def test_flattens_expectations_before_recording_invocations
      c = Class.new { def foo; end }
      expectation = ExpectationRecord.add_expectation(c, :foo, :track)
      expectation.add_return_values(1, "str", "sym")
      expectation.add_test_subject(:doesntmatter)
      ExpectationRecord.record_invocations
      ExpectationRecord.expectations.each { |val| assert(!val.is_a?(Array)) }
    end
    
    def test_fails_when_untested_expectations
      ExpectationRecord.add_expectation(Hash, :foo, :track)
      assert(ExpectationRecord.has_untested_expectations?)
    end
    
    def test_removes_expectation
      c = Class.new { def foo; end }
      expectation = ExpectationRecord.add_expectation(c, :foo, :track)
      ExpectationRecord.remove(expectation)
      assert_equal(0, ExpectationRecord.expectations.size)
    end
  end
end
