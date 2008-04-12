require "rubygems"
require "mocha_standalone"
require "expectations"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class ExpectationsAdapter < Adapter
    ignore_instances_of Class::AnyInstance
    
    def run
      fail_unless { Expectations::SuiteRunner.instance.suite.execute }
    end
    
    def stop_collecting_expectations
      Mocha::Expectation.class_eval do
        alias with original_with
        alias returns original_returns
        undef original_with
        undef original_returns
      end
      
      Object.class_eval do
        alias expects original_expects
        undef original_expects
      end
    end
  end
end

class Expectations::SuiteRunner  
  def initialize
    self.suite = Expectations::Suite.new
  end  
end

class Mocha::Expectation
  attr_accessor :synthesis_expectation

  alias original_with with

  def with(*expected_parameters, &matching_block)
    synthesis_expectation.args = expected_parameters if synthesis_expectation
    original_with(*expected_parameters, &matching_block)
  end
  
  alias original_returns returns
  
  def returns(*values)
    mocha_expectation = original_returns(*values)
    synthesis_expectation.add_return_values(*values) if synthesis_expectation
    mocha_expectation
  end
end

class Object
  alias original_expects expects
  
  def expects(meth)
    s_expectation = Synthesis::ExpectationRecord.add_expectation(self, meth, caller[0])
    m_expectation = original_expects(meth)
    m_expectation.synthesis_expectation = s_expectation
    m_expectation
  end
end