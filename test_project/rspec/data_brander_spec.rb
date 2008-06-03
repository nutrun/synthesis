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
  
  it "should return :ok when given :ok" do
    storage = Storage.new("")
    storage.should_receive(:ok_or_problem).with(:ok).and_return(:ok)
    DataBrander.new(storage).ok
  end
  
  it "should not rescue problem on not ok" do
    proc do
      storage = Storage.new("")
      storage.should_receive(:ok_or_problem).with(:not_ok).and_raise(Problem.new)
      DataBrander.new(storage).not_ok
    end.should raise_error(Problem)
  end
end