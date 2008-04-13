module Synthesis
  # Subclasses of Adapter must implement the run, collect_expectations and
  # stop_collecting_expectations methods. 
  # For example implementations refer to Synthesis::MochaAdapter and
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
      collect_expectations
      Dir[@pattern].each { |t| require t }
      exit -1 unless yield
      log "Verifying expectation invocations..."
      stop_collecting_expectations
      ExpectationRecord.record_invocations
      yield
    end
    
    # The type of object representing a mock or stub for the test framework. 
    # Objects of this type will be ignored by Synthesis.
    def ignore_instances_of(type)
      Synthesis.const_set(:MOCK_OBJECT, type)
    end
    
    class << self
      def inherited(subclass)
        @adapter = subclass
      end

      def load(pattern)
        @adapter.new(pattern)
      end
    end
  end
end