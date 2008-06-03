%w(rubygems spec fileutils).each { |l| require l }
require File.dirname(__FILE__) + "/../test_project"

describe Storage do
  it "should save to file" do
    begin
      Storage.new('test.txt').save('rock')
      File.read('test.txt').should == 'rock'
    ensure
      FileUtils.rm_f('test.txt')
    end
  end
  
  it "should raise problem on ouch!" do
    proc { Storage.new("").ouch! }.should raise_error(Problem)
  end
  
  it "should return :ok when given :ok" do
    Storage.new("").ok_or_problem(:ok).should == :ok
  end
  
  it "should raise problem when not give :ok" do
    proc { Storage.new("").ok_or_problem(:not_ok) }.should raise_error(Problem)
  end
end