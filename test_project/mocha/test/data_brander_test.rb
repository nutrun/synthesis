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
  
  def test_is_ok
    storage = Storage.new("")
    storage.expects(:ok_or_problem).with(:ok).returns(:ok)
    DataBrander.new(storage).ok
  end
  
  def test_does_not_rescue_problem_on_not_ok
    assert_raise(Problem) do
      storage = Storage.new("")
      storage.expects(:ok_or_problem).with(:not_ok).raises(Problem.new)
      DataBrander.new(storage).not_ok
    end
  end
  
  def test_mock_open_file
    data_brander = DataBrander.new
    data_brander.expects(:open).with(File.dirname(__FILE__) + '/../../test_project.rb')
    data_brander.open_file
  end
  
  def test_concreate_open_file
    DataBrander.new.open_file
  end
end