%w(test/unit rubygems mocha).each { |l| require l }
require File.dirname(__FILE__) + "/../../test_project"

class DataBranderTest < Test::Unit::TestCase
  def test_saves_branded_to_storage
    storage = Storage.new 'whatever'
    storage.expects(:save).with('METAL - rock')
    DataBrander.new(storage).save_branded('rock')
  end
  
  def test_ignores_total_ducks
    m = mock
    m.expects(:foo)
    m.foo
  end
  
  def test_delegates_problem
    storage = Storage.new("")
    storage.expects(:ouch!).raises(Problem.new)
    assert_raise(Problem) { DataBrander.new(storage).dont_do_this }
  end
end