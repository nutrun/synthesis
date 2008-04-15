require File.dirname(__FILE__) + "/helper"

module Synthesis
  class MethodsTest < Test::Unit::TestCase
    def teardown
      ExpectationRecord.expectations.clear
    end
    
    def test_records_singleton_method_expectation
      ExpectationRecord.should_receive(:add_expectation).with(Hash, :foo, an_instance_of(String))
      Hash.should_receive(:foo)
      Hash.foo
    end

    def test_records_instance_method_expectation
      hash = Hash.new
      ExpectationRecord.should_receive(:add_expectation).with(hash, :foo, an_instance_of(String))
      hash.should_receive(:foo)
      hash.foo
    end  
  end
end
