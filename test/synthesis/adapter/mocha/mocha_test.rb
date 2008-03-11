require File.dirname(__FILE__) + "/helper"

module Synthesis
  class MochaTest < Test::Unit::TestCase
    def test_sets_mock_object_to_class_any_instance
      assert_equal(Class::AnyInstance, Synthesis::MOCK_OBJECT)
    end
  end
end