require File.dirname(__FILE__) + "/helper"

class MochaExpectationTest < Test::Unit::TestCase
  def setup
    @mocha_expectation = Mocha::Expectation.new :mock, :blah
  end
  
  def test_holds_synthesis_expectation
    @mocha_expectation.synthesis_expectation = 1
    assert_equal(1, @mocha_expectation.synthesis_expectation)
  end
  
  def test_with_passes_expected_params_to_synthesis_expectation
    @mocha_expectation.synthesis_expectation = Synthesis::Expectation.new(Hash, :foo, :track)
    @mocha_expectation.with(1, 2)
    assert_equal([1, 2], @mocha_expectation.synthesis_expectation.args)
  end
end