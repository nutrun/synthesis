require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationTest < Test::Unit::TestCase
    def test_creates_singleton_method_expectation_given_class
      expectation = Expectation.new(Class.new, :foo, :track)
      assert_kind_of(Expectation::Singleton, expectation)
    end

    def test_creates_instance_method_expectation_given_instance
      expectation = Expectation.new(Class.new.new, :foo, :track)
      assert_kind_of(Expectation::Instance, expectation)
    end

    def test_creates_singleton_method_expectation_given_module
      expectation = Expectation.new(Module.new, :foo, :track)
      assert_kind_of(Expectation::Singleton, expectation)
    end

    def test_records_instance_receiver_method_invocations
      receiver = Class.new { def foo;end }
      expectation = Expectation.new(receiver.new, :foo, :track)
      expectation.record_invocations
      assert_respond_to(receiver.new, :__recordable__foo)
    end

    def test_records_singleton_receiver_method_invocations
      receiver = Class.new { def self.foo;end }
      expectation = Expectation.new(receiver, :foo, :track)
      expectation.record_invocations
      assert_respond_to(receiver, :__recordable__foo)
    end

    def test_equality
      exp1 = Expectation.new(Object.new, :foo, :track)
      exp2 = Expectation.new(Object.new, :foo, :track)
      assert_equal(exp1, exp2)
    end

    def test_non_equality
      exp1 = Expectation.new(Hash.new, :foo, :track)
      exp2 = Expectation.new(Array.new, :foo, :track)
      assert_not_equal(exp1, exp2)
    end
    
    def test_equality_based_on_same_type_args
      exp1 = Expectation.new(Object.new, :foo, :track, [1, 2])
      exp2 = Expectation.new(Object.new, :foo, :track, [1, 2])
      assert_equal(exp1, exp2)
    end
    
    def test_non_equality_based_on_different_type_args
      exp1 = Expectation.new(Object.new, :foo, :track, [1, Hash.new])
      exp2 = Expectation.new(Object.new, :foo, :track, [1, 2])
      assert_not_equal(exp1, exp2)
    end
    
    def test_equality_based_on_return_value
      exp1 = Expectation.new(Object.new, :foo, :track, [1], :return)
      exp2 = Expectation.new(Object.new, :foo, :track, [1], :return)
      assert_equal(exp1, exp2)
    end
    
    def test_non_equality_based_on_different_return_value_type_for_instance
      exp1 = Expectation.new(Object.new, :foo, :track, [1], :sym)
      exp2 = Expectation.new(Object.new, :foo, :track, [1], "string")
      assert_not_equal(exp1, exp2)
    end
    
    def test_non_equality_based_on_different_return_value_type_for_class
      exp1 = Expectation.new(Hash, :foo, :track, [1], :sym)
      exp2 = Expectation.new(Hash, :foo, :track, [1], "string")
      assert_not_equal(exp1, exp2)
    end
    
    def test_make_sure_equality_works_with_uniq
      arr = [
        Expectation.new(String, :new, []), 
        Expectation.new(String, :new, [])
      ]
      assert_equal(1, arr.uniq.size)
    end

    def silent(object)
      object.silence!
      yield
      object.speak!
    end
  end
end
