require "test/unit"
require "fileutils"
require File.dirname(__FILE__) + "/../../test_project"
require "rubygems"
require "mocha"

class StorageTest < Test::Unit::TestCase
  def test_saves_to_file
    Storage.new('test.txt').save('rock')
    assert_equal 'rock', File.read('test.txt')
  ensure
    FileUtils.rm_f('test.txt')
  end
  
  def test_ouch_raises_problem
    assert_raise(Problem) { Storage.new("").ouch! }
  end
  
  def test_ok_or_problem_returns_ok_when_given_ok
    assert_equal(:ok, Storage.new("").ok_or_problem(:ok))
  end
  
  def test_ok_raises_problem_when_not_given_ok
    assert_raise(Problem) { Storage.new("").ok_or_problem(:not_ok) }
  end
  
  def test_never_called
    storage = Storage.new("")
    storage.expects(:never_call_me).never
  end
end
