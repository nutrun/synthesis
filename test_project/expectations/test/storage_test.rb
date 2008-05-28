require "rubygems"
require "expectations"
require File.dirname(__FILE__) + "/../../test_project"

Expectations do
  expect "rock" do
    begin
      Storage.new('test.txt').save('rock')
      File.read 'test.txt'
    ensure
      FileUtils.rm_f 'test.txt'
    end
  end
  
  expect Problem do
    Storage.new("").ouch!
  end
end
