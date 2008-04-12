require "rubygems"
require "spec"
require "spec/mocks"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class RSpecAdapter < Adapter
    ignore_instances_of Spec::Mocks::Mock
    
    def run
      rspec_options.files.clear
      fail_unless { rspec_options.run_examples }
    end
    
    def stop_collecting_expectations
      Spec::Mocks::MessageExpectation.class_eval do
        alias with original_with
        alias and_return original_and_return
        undef original_with
        undef original_and_return
      end
      
      Spec::Mocks::Methods.module_eval do
        alias should_receive original_should_receive
        undef original_should_receive
      end
    end
  end  
end

module Spec::Mocks
  class MessageExpectation
    attr_accessor :synthesis_expectation

    alias original_with with

    def with(*expected_parameters, &matching_block)
      synthesis_expectation.args = expected_parameters if synthesis_expectation
      original_with(*expected_parameters, &matching_block)
    end

    alias original_and_return and_return

    def and_return(*values)
      spec_expectation = original_and_return(*values)
      synthesis_expectation.add_return_values(*values)
      spec_expectation
    end
  end
  
  module Methods
    alias original_should_receive should_receive
    
    def should_receive(meth)
      s_expectation = Synthesis::ExpectationRecord.add_expectation(self, meth, caller[0])
      m_expectation = original_should_receive(meth)
      m_expectation.synthesis_expectation = s_expectation
      m_expectation
    end
  end
end