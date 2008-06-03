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
      expectation = Expectation.new(receiver, :foo, :track, [], [:return])
      expectation.record_invocations
      assert_respond_to(receiver, :__recordable__foo)
    end
    
    def test_make_sure_equality_works_with_uniq
      expectations = [
        Expectation.new(String, :new, [], [:arg1, :arg2], [:return]), 
        Expectation.new(String, :new, [], [:arg1, :arg2], [:return])
      ]
      assert_equal(1, expectations.uniq.size)
    end
    
    def test_singleton_receiver_class
      assert_equal(String, Expectation.new(String, :new, :track).receiver_class)
    end
    
    def test_instance_receiver_class
      assert_equal(String, Expectation.new(String.new, :new, :track).receiver_class)
    end
    
    def test_arg_types
      expectation = Expectation.new(String.new, :new, :track, [:sym, "str"], [])
      assert_equal([Symbol, String], expectation.arg_types)
    end
        
    def test_return_value_type
      expectation = Expectation.new(String, :new, :track)
      expectation.add_return_values(:sym)
      assert_equal(Symbol, expectation.return_value_type)
    end
    
    def test_true_class_return_value_type
      expectation = Expectation.new(String, :new, :track)
      expectation.add_return_values(true)
      assert_equal(TrueClass, expectation.return_value_type)
    end
    
    def test_false_class_return_value_type
      expectation = Expectation.new(String, :new, :track)
      expectation.add_return_values(false)
      assert_equal(FalseClass, expectation.return_value_type)
    end
    
    def test_returns_nil_return_value_type_when_no_return_values
      expectation = Expectation.new(String, :new, :track)
      assert_nil(expectation.return_value_type)
    end
    
    def test_adds_return_value
      expectation = Expectation.new(String.new, :new, :track, [], [:sym])
      expectation.add_return_values("str")
      actual = expectation.instance_variable_get(:@return_values)
      assert_equal([:sym, "str"], actual)
    end
    
    def test_return_values_defined_when_return_values_added
      expectation = Expectation.new(String.new, :new, :track, [], [:sym])
      expectation.add_return_values("str")
      assert(expectation.return_values_defined?)
    end
    
    def test_return_values_not_defined_when_no_return_values_added
      expectation = Expectation.new(String.new, :new, :track, [], [:sym])
      assert(!expectation.return_values_defined?)
    end
    
    def test_explodes_to_new_expectations_for_each_return_value
      expectation = Expectation.new(String, :new, :track, [])
      expectation.add_return_values(:sym, "str")
      expectation.add_test_subject(:doesntmatter)
      expected = [
        Expectation.new(String, :new, :track, [], [:sym]),
        Expectation.new(String, :new, :track, [], ["str"])
      ]
      assert_equal(expected, expectation.explode)
    end
    
    def test_returns_self_when_only_one_return_type_on_explode
      expectation = Expectation.new(String, :new, :track, [])
      expectation.add_return_values("rock")
      assert_equal(expectation, expectation.explode)
    end

    def test_singleton_expectation_receiver_repr
      expectation = Expectation.new(String, :new, :track, [])
      assert_equal("String", expectation.receiver_repr)
    end
    
    def test_instance_expectation_receiver_repr
      expectation = Expectation.new(String.new, :new, :track, [])
      assert_equal("String.new", expectation.receiver_repr)
    end

    def test_expectation_sorting
      light = Expectation.new(Object.new, :bar, :track, [])
      heavy = Expectation.new(Object.new, :foo, :track, [], [:retval])
      sorted = [light, heavy].sort.reverse
      assert_equal(heavy, sorted[0])
      assert_equal(light, sorted[1])
    end
  end
end
