module Synthesis
  # Subclasses of Adapter must implement the "run" method. 
  # For example implementations, refer to Synthesis::MochaAdapter and
  # Synthesis::RSpecAdapter
  class Adapter
    include Logging
    
    def initialize(pattern)
      @pattern = pattern
    end
    
    # The block parameter will yield twice, once for collecting and
    # once for verifying the collected expectations. 
    def fail_unless(&block)
      log "Collecting expectations..."
      Dir[@pattern].each { |t| require t }
      exit -1 unless yield
      log "Verifying expectation invocations..."
      stop_collecting_expectations
      ExpectationRecord.record_invocations
      yield
    end
    
    class << self
      # The type of object representing a mock or stub for the test framework. 
      # Objects of this type will be ignored by Synthesis.
      def ignore_instances_of(type)
        Synthesis.const_set(:MOCK_OBJECT, type)
      end
      
      # The class representing a mock object expectation in the test framework. 
      # Synthesis will intercept its "with" method in order to collect the
      # expectation method parameters being passed to it. 
      def expectation_class(klass)
        klass.class_eval do
          attr_accessor :synthesis_expectation

          alias original_with with

          def with(*expected_parameters, &matching_block)
            synthesis_expectation.args = expected_parameters if synthesis_expectation
            original_with(*expected_parameters, &matching_block)
          end
        end
      end
      
      # Accepts a Hash parameter with two entries, :method and :on. These
      # represent the name of the method used for declaring a method interaction
      # expectation on an object and the name of the object the method is defined
      # on respectively. Synthesis will intercept this method in order to collect
      # simulated method interactions. 
      def intercept(params)
        method_name, obj = params[:method], params[:on]
        obj.send(:alias_method, :original_meth, method_name)
        obj.send(:define_method, method_name) do |meth|
          s_expectation = Synthesis::ExpectationRecord.add_expectation(self, meth, caller[0])
          m_expectation = original_meth(meth)
          m_expectation.synthesis_expectation = s_expectation
          m_expectation
        end
      end
      
      def inherited(subclass)
        @adapter = subclass
      end

      def load(pattern)
        @adapter.new(pattern)
      end
    end
  end
end