require "rubygems"
require "expectations"
require File.dirname(__FILE__) + "/../../test_project"

Expectations do
  expect Storage.new('whatever').to.receive(:save).with('METAL - rock') do |storage|
    DataBrander.new(storage).save_branded 'rock'
  end
  
  expect Storage.new("").to.receive(:ouch!).raises(Problem.new) do |storage|
    begin
      DataBrander.new(storage).dont_do_this
    rescue Problem
      return true
    end
    fail
  end
    
  expect Storage.new("").to.receive(:ok_or_problem).with(:ok).returns(:ok) do |s|
    DataBrander.new(s).ok
  end
    
  expect Problem do
    storage = Storage.new("")
    storage.expects(:ok_or_problem).with(:not_ok).raises(Problem.new)
    DataBrander.new(storage).not_ok
  end
end
