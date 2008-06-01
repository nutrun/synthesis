require "rubygems"
require "mocha_standalone"
require "test/unit"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class MochaAdapter < Adapter
    def run
      Test::Unit.run = true # Yes means no...
      fail_unless { Test::Unit::AutoRunner.run }
    end
    
    def collect_expectations
      ignore_instances_of Class::AnyInstance
      Object.extend(ExpectationRecordEnabled)
      Object.record_expectations_on(:expects)
      Mocha::Expectation.extend(ExpectationInterceptor)
      Mocha::Expectation.record_test_subject_on(:invoke)
      Mocha::Expectation.record_expected_arguments_on(:with)
      Mocha::Expectation.record_expected_return_values_on(:returns)
      Mocha::Expectation.record_expected_return_values_on(:raises)
    end
    
    def stop_collecting_expectations
      Mocha::Expectation.stop_intercepting!
      Object.stop_recording!
    end
  end  
end
