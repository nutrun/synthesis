require "rubygems"
require "spec"
require "spec/mocks"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class RSpecAdapter < Adapter
    def run
      fail_unless do
        rspec_opts = begin
          Spec::Runner.options
        rescue
          rspec_options
        end
        
        rspec_opts.files.clear
        rspec_opts.instance_variable_set(:@formatters, nil)
        rspec_opts.run_examples
        # Synthesis.rspec_runner_options.instance_variable_set(:@format_options, [["profile", STDOUT]])
      end
    end
    
    def collect_expectations
      ignore_instances_of Spec::Mocks::Mock
      Spec::Mocks::Methods.extend(ExpectationRecorder)
      Spec::Mocks::Methods.record_expectations_on(:should_receive)
      Spec::Mocks::MessageExpectation.extend(ExpectationInterceptor)
      Spec::Mocks::MessageExpectation.intercept_test_subject_on(:invoke)
      Spec::Mocks::MessageExpectation.intercept_expected_arguments_on(:with)
      Spec::Mocks::MessageExpectation.intercept_expected_return_values_on(:and_return)
      Spec::Mocks::MessageExpectation.intercept_expected_return_values_on(:and_raise)
      Spec::Mocks::MessageExpectation.remove_expectation_on(:never)
    end
    
    def stop_collecting_expectations
      Spec::Mocks::MessageExpectation.stop_intercepting!
      Spec::Mocks::Methods.stop_recording!
    end
  end
end
