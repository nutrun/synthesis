require "rubygems"
require "mocha_standalone"
require "expectations"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class ExpectationsAdapter < Adapter
    def run
      fail_unless { Expectations::SuiteRunner.instance.suite.execute }
    end
    
    def collect_expectations
      ignore_instances_of Class::AnyInstance
      Object.extend(ExpectationRecorder)
      Object.record_expectations_on(:expects)
      Mocha::Expectation.extend(ExpectationInterceptor)
      Mocha::Expectation.intercept_test_subject_on(:invoke)
      Mocha::Expectation.intercept_expected_arguments_on(:with)
      Mocha::Expectation.intercept_expected_return_values_on(:returns)
      Mocha::Expectation.intercept_expected_return_values_on(:raises)
      Mocha::Expectation.remove_expectation_on(:never)
    end
    
    def stop_collecting_expectations
      Mocha::Expectation.stop_intercepting!
      Object.stop_recording!
    end
  end
end

class Expectations::SuiteRunner  
  def initialize
    self.suite = Expectations::Suite.new
  end  
end
