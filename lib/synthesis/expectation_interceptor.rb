module Synthesis
  module ExpectationInterceptor
    def intercept_expected_argument_types_on(method_name)
      @original_with = method_name
      
      class_eval %(
        alias intercepted_#{@original_with} #{@original_with}
        
        def #{@original_with}(*expected_parameters, &matching_block)
          synthesis_expectation.args = expected_parameters if synthesis_expectation
          intercepted_#{@original_with}(*expected_parameters, &matching_block)
        end
      )
    end
    
    def intercept_expected_return_values_on(method_name)
      @original_returns = method_name
      
      class_eval %(
        alias intercepted_#{@original_returns} #{@original_returns}

        def #{@original_returns}(*values)
          mock_expectation = intercepted_#{@original_returns}(*values)
          synthesis_expectation.add_return_values(*values) if synthesis_expectation
          mock_expectation
        end
      )
    end
    
    def reset!
      class_eval %(
        alias #{@original_with} intercepted_#{@original_with}
        alias #{@original_returns} intercepted_#{@original_returns}
        undef intercepted_#{@original_with}
        undef intercepted_#{@original_returns}
      )
    end
    
    def self.extended(receiver)
      receiver.send(:attr_accessor, :synthesis_expectation)
    end
  end
end
