require File.dirname(__FILE__) + "/helper"

class ObjectTest < Test::Unit::TestCase
  def test_has_instance_expectation
    assert_instance_of Synthesis::Expectation::Instance, Object.new.expectation(:foo, :track)
  end
end