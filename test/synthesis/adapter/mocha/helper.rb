%w(test/unit rubygems mocha).each { |l| require l }
require File.dirname(__FILE__) + "/../../../../lib/synthesis/adapter/mocha"
Synthesis::MochaAdapter.new(nil).collect_expectations