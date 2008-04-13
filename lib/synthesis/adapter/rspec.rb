require "rubygems"
require "spec"
require "spec/mocks"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class RSpecAdapter < Adapter
    def run
      rspec_options.files.clear
      fail_unless { rspec_options.run_examples }
    end
    
    def collect_expectations
      ignore_instances_of Spec::Mocks::Mock
      Spec::Mocks::MessageExpectation.extend(ExpectationInterceptor)
      Spec::Mocks::MessageExpectation.intercept_expected_argument_types_on(:with)
      Spec::Mocks::MessageExpectation.intercept_expected_return_values_on(:and_return)
      Spec::Mocks::Methods.extend(ExpectationRecordEnabled)
      Spec::Mocks::Methods.record_expectations_on(:should_receive)
    end
    
    def stop_collecting_expectations
      Spec::Mocks::MessageExpectation.reset!
      Spec::Mocks::Methods.reset!
    end
  end  
end
