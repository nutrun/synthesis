module Synthesis
  # Extend by the mock object framework's expectation mechanism to allow
  # Synthesis to tap into it in order to collect simulated method arguments
  # and return values.
  module ExpectationInterceptor
    # Intercept the actual mock proxy to record the test subject so that
    # Synthesis can track which object is being tested
    def intercept_test_subject_on(method_name)
      (@original_methods ||= []) << method_name
      
      class_eval do
        alias_method "intercepted_#{method_name}", method_name
        
        define_method(:get_invoke_method_name) {method_name}
        
        def temp_invoke(*expected_parameters, &matching_block)
          synthesis_expectation.add_test_subject(callstack) if synthesis_expectation
          send("intercepted_#{get_invoke_method_name}", *expected_parameters, &matching_block)
        end
          
        alias_method method_name, :temp_invoke
        undef temp_invoke
      end
    end
    
    # Intercept the mock object framework's expectation method for declaring a mocked
    # method's arguments so that Synthesis can record them.
    def intercept_expected_arguments_on(method_name)
      (@original_methods ||= []) << method_name
      
      class_eval do
        alias_method "intercepted_#{method_name}", method_name
        
        define_method(:get_method_name) {method_name}
        
        def temp_method(*expected_parameters, &matching_block)
          synthesis_expectation.args = expected_parameters if synthesis_expectation
          send("intercepted_#{get_method_name}", *expected_parameters, &matching_block)
        end
        
        alias_method method_name, :temp_method
        undef temp_method
      end
    end
    
    # Intercept the mock object framework's expectation method for declaring a mocked
    # method's return values so that Synthesis can record them.
    def intercept_expected_return_values_on(method_name)
      (@original_methods ||= []) << method_name
      
      class_eval do
        alias_method "intercepted_#{method_name}", method_name
        
        define_method(method_name) do |*values|
          mock_expectation = send("intercepted_#{method_name}", *values)
          synthesis_expectation.add_return_values(*values) if synthesis_expectation
          mock_expectation
        end
      end
    end
    
    def remove_expectation_on(method_name)
      (@original_methods ||= []) << method_name
      
      class_eval do
        alias_method "intercepted_#{method_name}", method_name
        
        define_method(method_name) do |*values|
          Synthesis::ExpectationRecord.remove(synthesis_expectation) if synthesis_expectation
          send("intercepted_#{method_name}")
        end
      end
    end
    
    # Restore the original methods ExpectationInterceptor has rewritten and
    # undefine their intercepted counterparts. Undefine the synthesis_expectation
    # accessors.
    def stop_intercepting!
      @original_methods.each do |m|
        class_eval do
          alias_method m, "intercepted_#{m}"
          remove_method "intercepted_#{m}"
        end
      end

      class_eval do
        remove_method :synthesis_expectation
        remove_method :synthesis_expectation=
        remove_method :get_invoke_method_name
        remove_method :get_method_name
      end
    end
    
    # Classes extending ExpectationInterceptor will have a synthesis_expectation
    # attribute accessor added to them.
    def self.extended(receiver)
      receiver.send(:attr_accessor, :synthesis_expectation)
    end
  end
end
