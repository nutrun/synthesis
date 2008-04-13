module Synthesis
  # Extend by the mock object framework's construct for declaring a
  # mock object so that Synthesis can tap into it in order to record
  # the expectation.
  module ExpectationRecordEnabled
    # Intercept the mock object framework's method for declaring a mock
    # object so that Synthesis can record it.
    def record_expectations_on(method_name)
      @original_expects = method_name
      
      class_eval %(
        alias intercepted_#{@original_expects} #{@original_expects}

        def #{@original_expects}(meth)
          s_expectation = Synthesis::ExpectationRecord.add_expectation(self, meth, caller[0])
          m_expectation = intercepted_#{@original_expects}(meth)
          m_expectation.synthesis_expectation = s_expectation
          m_expectation
        end
      )
    end
    
    # Restore the original methods ExpectationRecordEnabled has rewritten and
    # undefine their intercepted counterparts.
    def reset!
      class_eval %(
        alias #{@original_expects} intercepted_#{@original_expects}
        undef intercepted_#{@original_expects}
      )
    end
  end
end