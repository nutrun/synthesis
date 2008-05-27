require File.dirname(__FILE__) + "/helper"

class ClassTest < Test::Unit::TestCase
  def test_has_singleton_expectation
    assert_instance_of(Synthesis::Expectation::Singleton, Hash.expectation(:foo, :track))
  end
end