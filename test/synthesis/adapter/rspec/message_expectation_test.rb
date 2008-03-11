require File.dirname(__FILE__) + "/helper"

class MessageExpectationTest < Test::Unit::TestCase
  def setup
    error_generator = Class.new {def opts=(param)end}.new
    @spec_expectation = Spec::Mocks::MessageExpectation.new error_generator, :n, :n, :n, :n
  end
  
  def test_holds_synthesis_expectation
    @spec_expectation.synthesis_expectation = 1
    assert_equal 1, @spec_expectation.synthesis_expectation
  end
  
  def test_with_passes_expected_params_to_synthesis_expectation
    @spec_expectation.synthesis_expectation = Synthesis::Expectation.new Hash, :foo, :track
    @spec_expectation.with 1, 2
    assert_equal([1, 2], @spec_expectation.synthesis_expectation.args)
  end
end