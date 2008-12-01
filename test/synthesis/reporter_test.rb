require File.dirname(__FILE__) + "/helper"

module Synthesis
  class ReporterTest < Test::Unit::TestCase
    def setup
      @formatter = mock
      @formatter.stubs(:format_failure)
      @formatter.stubs(:format_success)
      Formatter.stubs(:load).returns(@formatter)
      # TextFormatter.stubs(:new).returns(@formatter)
      
      @out = mock
      File.stubs(:open).returns(@out)
      @out.stubs(:close)
    end
    
    def test_loads_formatter
      Formatter.expects(:load).with(@out).returns(@formatter)
      Reporter.report(:text, 'output')
    end
    
    def test_format_success_when_all_expectations_met
      ExpectationRecord.expects(:has_untested_expectations?).returns(false)
      @formatter.expects(:format_success)
      assert_equal 0, Reporter.report(:text, 'output')
    end

    def test_format_failure_when_not_all_expectations_met
      ExpectationRecord.expects(:has_untested_expectations?).returns(true)
      @formatter.expects(:format_failure)
      assert_equal -1, Reporter.report(:text, 'output')
    end
    
    def test_default_formatter_out_should_be_stdout
      Formatter.expects(:load).with(STDOUT).returns(@formatter)
      File.expects(:open).never
      Reporter.report(:text, nil)
    end
    
    def test_custom_formatter_out_should_open_and_close_file
      File.expects(:open).with('output_file', 'w').returns(@out)
      @out.expects(:close)
      Reporter.report(:text, 'output_file')
    end
    
    def test_raises_nice_error_for_invalid_format
      assert_raises RuntimeError, :message => "Invalid format: invalid" do
        Reporter.report(:invalid, nil)
      end
    end
  end
end