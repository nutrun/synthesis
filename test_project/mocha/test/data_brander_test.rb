%w(test/unit rubygems mocha).each { |l| require l }
require File.dirname(__FILE__) + "/../../test_project"

class DataBranderTest < Test::Unit::TestCase
  def test_saves_branded_to_pstore
    pstore = Storage.new 'whatever'
    pstore.expects(:save).with('METAL - rock')
    DataBrander.new(pstore).save_branded 'rock'
  end
  
  def test_ignores_total_ducks
    m = mock
    m.expects(:foo)
    m.foo
  end
end