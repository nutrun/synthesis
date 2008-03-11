require "test/unit"
require "fileutils"
require File.dirname(__FILE__) + "/../../test_project"

class StorageTest < Test::Unit::TestCase
  def test_saves_to_file
    Storage.new('test.txt').save('rock')
    assert_equal 'rock', File.read('test.txt')
  ensure
    FileUtils.rm_f('test.txt')
  end
end
