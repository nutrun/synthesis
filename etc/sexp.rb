require "rubygems"
require "parse_tree"
require "sexp_processor"
require "test/unit"

# class Nothing
#   def self.one
#     1
#   end
# end
# 
# class RockTest < Test::Unit::TestCase
#   def test_something
#     # noth = Nothing.new
#     assert_equal(1, Nothing.one)
#   end
#   
#   def test_someting_else
#     assert(true, "Failure message.")
#   end
# end

# tests = RockTest.instance_methods.select { |m| m =~ /^test_.*$/ }
# test_p_trees = tests.map { |t| ParseTree.new.parse_tree_for_method(RockTest, t.to_sym) }
# p ParseTree.translate(RockTest)
# p test_p_trees.fcalls

require File.dirname(__FILE__) + "/../test/test_data/one_test"
p ParseTree.translate(OneTest)