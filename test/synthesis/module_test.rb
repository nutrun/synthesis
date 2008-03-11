require File.dirname(__FILE__) + "/helper"

class ModuleTest < Test::Unit::TestCase
  def test_has_singleton_expectation
    assert_instance_of Synthesis::Expectation::Singleton, Module.new.expectation(:foo, :track)
  end
end