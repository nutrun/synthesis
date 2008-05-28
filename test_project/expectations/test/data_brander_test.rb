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
end
