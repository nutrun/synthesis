require "rubygems"
require "expectations"
require File.dirname(__FILE__) + "/../../test_project"

Expectations do
  expect Storage.new('whatever').to.receive(:save).with('METAL - rock') do |storage|
    DataBrander.new(storage).save_branded 'rock'
  end
end
