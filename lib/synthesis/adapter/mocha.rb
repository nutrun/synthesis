require "rubygems"
require "mocha_standalone"
require "test/unit"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class MochaAdapter < Adapter

    ignore_instances_of Class::AnyInstance
    # expectation_class Mocha::Expectation
    intercept :method => :expects, :on => Object
    
    def run
      Test::Unit.run = true # Yes means no...
      fail_unless { Test::Unit::AutoRunner.run }
    end
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
    #FIXME: Simple for now, fix later...
    synthesis_expectation.return_value = values.last
    mocha_expectation
  end
end