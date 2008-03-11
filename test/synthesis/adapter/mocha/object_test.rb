require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ObjectTest < Test::Unit::TestCase
    def test_records_singleton_method_expectation
      ExpectationRecord.expects(:add_expectation).with(Hash, :foo, kind_of(String))
      Hash.expects(:foo)
      Hash.foo
    end

    def test_records_instance_method_expectation
      hash = Hash.new
      ExpectationRecord.expects(:add_expectation).with(hash, :foo, kind_of(String))
      hash.expects(:foo)
      hash.foo
    end  
  end
end
