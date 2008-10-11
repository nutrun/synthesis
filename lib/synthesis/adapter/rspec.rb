require "rubygems"
require "spec"
require "spec/mocks"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class RSpecAdapter < Adapter
    def run
      Synthesis.rspec_runner_options.files.clear
      fail_unless do
        Synthesis.rspec_runner_options.instance_variable_set(:@formatters, nil)
        # Synthesis.rspec_runner_options.instance_variable_set(:@format_options, [["profile", STDOUT]])
        Synthesis.rspec_runner_options.run_examples
      end
    end
    
    def collect_expectations
      ignore_instances_of Spec::Mocks::Mock
      Spec::Mocks::Methods.extend(ExpectationRecordEnabled)
      Spec::Mocks::Methods.record_expectations_on(:should_receive)
      Spec::Mocks::MessageExpectation.extend(ExpectationInterceptor)
      Spec::Mocks::MessageExpectation.record_test_subject_on(:invoke)
      Spec::Mocks::MessageExpectation.record_expected_arguments_on(:with)
      Spec::Mocks::MessageExpectation.record_expected_return_values_on(:and_return)
      Spec::Mocks::MessageExpectation.record_expected_return_values_on(:and_raise)
      Spec::Mocks::MessageExpectation.remove_expectation_on(:never)
    end
    
    def stop_collecting_expectations
      Spec::Mocks::MessageExpectation.stop_intercepting!
      Spec::Mocks::Methods.stop_recording!
    end
  end
  
  def rspec_runner_options
    Spec::Runner.options rescue rspec_options
  end
  
  module_function :rspec_runner_options
end
