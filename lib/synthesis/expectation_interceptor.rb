module Synthesis
  # Extend by the mock object framework's expectation mechanism to allow
  # Synthesis to tap into it in order to collect simulated method arguments
  # and return values.
  module ExpectationInterceptor
    # Intercept the mock object framework's expectation method for declaring a mocked
    # method's arguments so that Synthesis can record them.
    def record_expected_argument_types_on(method_name)
      @original_with = method_name
      
      class_eval <<-end_eval
        alias intercepted_#{@original_with} #{@original_with}
        
        def #{@original_with}(*expected_parameters, &matching_block)
          synthesis_expectation.args = expected_parameters if synthesis_expectation
          intercepted_#{@original_with}(*expected_parameters, &matching_block)
        end
      end_eval
    end
    
    # Intercept the mock object framework's expectation method for declaring a mocked
    # method's return values so that Synthesis can record them.
    def record_expected_return_values_on(method_name)
      @original_returns = method_name
      
      class_eval do
        alias_method "intercepted_#{method_name}", method_name
        
        define_method(method_name) do |*values|
          mock_expectation = send("intercepted_#{method_name}", *values)
          synthesis_expectation.add_return_values(*values) if synthesis_expectation
          mock_expectation
        end
      end
    end
    
    # Restore the original methods ExpectationInterceptor has rewritten and
    # undefine their intercepted counterparts. Undefine the synthesis_expectation
    # accessors.
    def stop_intercepting!
      with_method, returns_method = @original_with, @original_returns
      class_eval do
        alias_method with_method, "intercepted_#{with_method}"
        alias_method returns_method, "intercepted_#{returns_method}"
        remove_method "intercepted_#{with_method}"
        remove_method "intercepted_#{returns_method}"
        remove_method :synthesis_expectation
        remove_method :synthesis_expectation=
      end
    end
    
    # Classes extending ExpectationInterceptor will have a synthesis_expectation
    # attribute accessor added to them.
    def self.extended(receiver)
      receiver.send(:attr_accessor, :synthesis_expectation)
    end
  end
end
