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
  
  expect(Problem) { Storage.new("").ouch! }
  
  expect(Storage.new("").to.receive(:never_call_me).never) {}

  expect(:ok) { Storage.new("").ok_or_problem(:ok) }
  
  expect(Problem) {Storage.new("").ok_or_problem(:not_ok)}
  
end
