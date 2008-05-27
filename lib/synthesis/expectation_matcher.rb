module Synthesis
  class ExpectationMatcher
    def initialize(expectation_one, expectation_two)
      @expectation_one, @expectation_two = expectation_one, expectation_two
    end
    
    def match?
      return false unless @expectation_one.class == @expectation_two.class
      return false unless @expectation_one.receiver_class == @expectation_two.receiver_class
      return false unless @expectation_one.method == @expectation_two.method
      return false unless @expectation_one.arg_types == @expectation_two.arg_types
      return false unless return_values_match?
      true
    end
    
    private
    
    def return_values_match?
      return true unless @expectation_one.return_values_defined? || @expectation_two.return_values_defined?
      @expectation_one.return_value_type == @expectation_two.return_value_type
    end
  end
end