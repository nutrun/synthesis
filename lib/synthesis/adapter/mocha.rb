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
      Mocha::Expectation.extend(ExpectationInterceptor)
      Mocha::Expectation.intercept_expected_argument_types_on(:with)
      Mocha::Expectation.intercept_expected_return_values_on(:returns)
      Object.extend(ExpectationRecordEnabled)
      Object.record_expectations_on(:expects)
    end
    
    def stop_collecting_expectations
      Mocha::Expectation.reset!
      Object.reset!
    end
  end  
end
