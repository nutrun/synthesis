require "test/unit"
require File.dirname(__FILE__) + "/../../../../lib/synthesis/adapter/rspec"
Synthesis::RSpecAdapter.new(nil).collect_expectations