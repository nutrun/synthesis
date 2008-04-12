require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationMatcherTest < Test::Unit::TestCase
    def test_match
      exp1 = Expectation.new(Object.new, :foo, :track, [Array, Hash], [Array, Hash])
      exp2 = Expectation.new(Object.new, :foo, :track, [Array, Hash], [Array, Hash])
      assert(ExpectationMatcher.new(exp1, exp2).match?)
    end
    
    def test_no_match_based_on_expectation_type
      exp1 = Expectation.new(Array, :foo, :track, [Array, Hash], [Array, Hash])
      exp2 = Expectation.new(Array.new, :foo, :track, [Array, Hash], [Array, Hash])
      assert(!ExpectationMatcher.new(exp1, exp2).match?)
    end
    
    def test_no_match_based_on_receiver_type
      exp1 = Expectation.new(Array.new, :foo, :track, [Array, Hash], [Array, Hash])
      exp2 = Expectation.new(Hash.new, :foo, :track, [Array, Hash], [Array, Hash])
      assert(!ExpectationMatcher.new(exp1, exp2).match?)
    end
    
    def test_no_match_based_on_method_name
      exp1 = Expectation.new(Object.new, :foo, :track, [Array, Hash], [Array, Hash])
      exp2 = Expectation.new(Object.new, :bar, :track, [Array, Hash], [Array, Hash])
      assert(!ExpectationMatcher.new(exp1, exp2).match?)
    end
    
    def test_no_match_based_on_arg_types
      exp1 = Expectation.new(Object.new, :foo, :track, [1, "a"], [Array, Hash])
      exp2 = Expectation.new(Object.new, :foo, :track, [1, 2], [Array, Hash])
      assert(!ExpectationMatcher.new(exp1, exp2).match?)
    end
    
    def test_no_match_based_on_return_value_types
      exp1 = Expectation.new(Object.new, :foo, :track, [Array, Hash], [:sym])
      exp2 = Expectation.new(Object.new, :foo, :track, [Array, Hash], ["string"])
      assert(!ExpectationMatcher.new(exp1, exp2).match?)
    end
    
    def test_match_based_on_intersection_of_return_value_types
      exp1 = Expectation.new(Object.new, :foo, :track, [Array, Hash], [[1], {:a => :b}])
      exp2 = Expectation.new(Object.new, :foo, :track, [Array, Hash], [[4], {:a => 9}])
      assert(ExpectationMatcher.new(exp1, exp2).match?)
    end
  end  
end
