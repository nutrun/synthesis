%w(rubygems spec fileutils).each { |l| require l }
require File.dirname(__FILE__) + "/../test_project"

describe DataBrander do
  it "should save branded to pstore" do
    pstore = Storage.new 'whatever'
    pstore.should_receive(:save).with('METAL - rock')
    DataBrander.new(pstore).save_branded 'rock'
  end
  
  it "should ignore total ducks" do
    m = mock(Storage)
    m.should_receive(:foo)
    m.foo
  end
  
  it "should delegate problem" do
    storage = Storage.new("")
    storage.should_receive(:ouch!).and_raise(Problem.new)
    proc {DataBrander.new(storage).dont_do_this}.should raise_error(Problem)
  end
end