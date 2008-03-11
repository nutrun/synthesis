require "rubygems"
require "spec"
require "spec/mocks"

require File.dirname(__FILE__) + "/../../synthesis"

module Synthesis
  class RSpecAdapter < Adapter

    ignore_instances_of Spec::Mocks::Mock
    expectation_class Spec::Mocks::MessageExpectation
    intercept :method => :should_receive, :on => Spec::Mocks::Methods
    
    def run
      rspec_options.files.clear
      fail_unless { rspec_options.run_examples }
    end
  end  
end
