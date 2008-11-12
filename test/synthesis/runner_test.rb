require File.dirname(__FILE__) + "/helper"
require 'synthesis/adapter/mocha'

module Synthesis
  class RunnerTest < Test::Unit::TestCase
    def setup
      @adapter = mock
      @adapter.stubs(:run)
    end
    
    def test_loads_adapter
      MochaAdapter.expects(:new).with('*.rb').returns(@adapter)
      Runner.run(:mocha, '*.rb', :text, nil)
    end
    
    def test_raises_nice_error_for_invalid_format
      assert_raise RuntimeError, :message => "Invalid adapter: junit" do
        Runner.run(:junit, anything, :text, nil)
      end
    end
  end
end