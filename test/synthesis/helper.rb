%w(test/unit rubygems mocha).each { |l| require l }
require File.dirname(__FILE__) + "/../../lib/synthesis"
require "synthesis/task"
require "synthesis/runner"
MOCK_OBJECT = Class.new {}