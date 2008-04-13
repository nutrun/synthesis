module Synthesis
  module ExpectationRecordEnabled
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
    
    def reset!
      class_eval %(
        alias #{@original_expects} intercepted_#{@original_expects}
        undef intercepted_#{@original_expects}
      )
    end
  end
end