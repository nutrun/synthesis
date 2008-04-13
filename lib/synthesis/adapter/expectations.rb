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
      Object.extend(ExpectationRecordEnabled)
      Object.record_expectations_on(:expects)
      Mocha::Expectation.extend(ExpectationInterceptor)
      Mocha::Expectation.intercept_expected_argument_types_on(:with)
      Mocha::Expectation.intercept_expected_return_values_on(:returns)
    end
    
    def stop_collecting_expectations
      Mocha::Expectation.reset!
      Object.reset!
    end
  end
end

class Expectations::SuiteRunner  
  def initialize
    self.suite = Expectations::Suite.new
  end  
end
