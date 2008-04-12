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
      assert_equal(String, Expectation.new(String, :new, :track, [], []).receiver_class)
    end
    
    def test_instance_receiver_class
      assert_equal(String, Expectation.new(String.new, :new, :track, [], []).receiver_class)
    end
    
    def test_arg_types
      expectation = Expectation.new(String.new, :new, :track, [:sym, "str"], [])
      assert_equal([Symbol, String], expectation.arg_types)
    end
    
    def test_return_value_types
      expectation = Expectation.new(String.new, :new, :track, [], [:sym, "str"])
      assert_equal([Symbol, String], expectation.return_value_types)
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
  end
end
