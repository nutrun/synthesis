require "rubygems"
require "mocha_standalone"
require "expectations"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class ExpectationsAdapter < Adapter
 
    ignore_instances_of Class::AnyInstance
    expectation_class Mocha::Expectation
    intercept :method => :expects, :on => Object
    
    def run
      fail_unless { Expectations::SuiteRunner.instance.suite.execute }
    end
  end
end

class Expectations::SuiteRunner  
  def initialize
    self.suite = Expectations::Suite.new
  end  
end
