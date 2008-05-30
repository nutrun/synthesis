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
end