require "rubygems"
require "mocha_standalone"
require "test/unit"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class MochaAdapter < Adapter

    ignore_instances_of Class::AnyInstance
    expectation_class Mocha::Expectation
    intercept :method => :expects, :on => Object
    
    def run
      Test::Unit.run = true # Yes means no...
      fail_unless { Test::Unit::AutoRunner.run }
    end
  end  
end
