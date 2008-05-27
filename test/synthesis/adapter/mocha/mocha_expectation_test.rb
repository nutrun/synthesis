require File.dirname(__FILE__) + "/helper"

class MochaExpectationTest < Test::Unit::TestCase
  def setup
    @mocha_expectation = Mocha::Expectation.new(:mock, :blah)
    @synthesis_expectation = Synthesis::Expectation.new(Hash, :method, :track, [], [1])
  end
  
  def test_holds_synthesis_expectation
    @mocha_expectation.synthesis_expectation = @synthesis_expectation
    assert_equal(@synthesis_expectation, @mocha_expectation.synthesis_expectation)
  end
  
  def test_with_passes_expected_params_to_synthesis_expectation
    @mocha_expectation.synthesis_expectation = @synthesis_expectation
    @mocha_expectation.with(1, 2)
    assert_equal([1, 2], @mocha_expectation.synthesis_expectation.args)
  end
  
  def test_passes_return_values_to_synthesis_expectation
    @mocha_expectation.synthesis_expectation = @synthesis_expectation
    @mocha_expectation.returns(:rock)
    return_values = @synthesis_expectation.instance_variable_get(:@return_values)
    assert_equal([1, :rock], return_values)
  end
end