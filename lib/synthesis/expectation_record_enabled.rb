module Synthesis
  # Extend by the mock object framework's construct for declaring a
  # mock object so that Synthesis can tap into it in order to record
  # the expectation.
  module ExpectationRecordEnabled
    # Intercept the mock object framework's method for declaring a mock
    # object so that Synthesis can record it.
    def record_expectations_on(method_name)
      @original_expects = method_name
      
      class_eval do
        alias_method "intercepted_#{method_name}", method_name

        define_method(method_name) do |meth|
          s_expectation = ExpectationRecord.add_expectation(self, meth, caller[0])
          m_expectation = send("intercepted_#{method_name}", meth)
          m_expectation.synthesis_expectation = s_expectation
          m_expectation
        end
      end
    end
    
    # Restore the original methods ExpectationRecordEnabled has rewritten and
    # undefine their intercepted counterparts.
    def stop_recording!
      method_name = @original_expects
      class_eval do
        alias_method method_name, "intercepted_#{method_name}"
        remove_method "intercepted_#{method_name}"
      end
    end
  end
end