require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ExpectationRecordTest < Test::Unit::TestCase
    def teardown
      ExpectationRecord.expectations.clear
    end

    def test_does_not_add_any_instance_expectation
      mock = Spec::Mocks::Mock.new(Numeric)
      ExpectationRecord.add_expectation(mock, :foo, :track)
      assert_equal(0, ExpectationRecord.expectations.size)
    end  
  end
end
