require File.dirname(__FILE__) + "/helper"

module Synthesis
  class TaskTest < Test::Unit::TestCase
    def setup
      Task.any_instance.expects(:task).yields
      Task.any_instance.expects(:require).times(2)
    end

    def test_filters_based_on_a_pattern
      Runner.expects(:run).with(anything, '*.rb', :text, anything)
      Task.new { |t| t.pattern = '*.rb' }
    end

    def test_outputs_result_to_a_file
      file = stub
      File.stubs(:new).returns(file)
      Logging.expects(:const_set).with(:OUT, file) 
      Runner.expects(:run)
      Task.new { |t| t.out = File.new "synthesis.test.txt", "a" }
    end
    
    def test_selects_the_rspec_adapter
      Runner.expects(:run).with(:rspec, anything, :text, anything)
      Task.new { |t| t.adapter = :rspec }
    end

    def test_uses_mocha_as_the_default_adapter
      Runner.expects(:run).with(:mocha, anything, :text, anything)
      Task.new
    end

    def test_ignores_selected_classes
      ExpectationRecord.expects(:ignore).with(Array, Hash)
      Runner.expects(:run).with(:mocha, anything, :text, anything)
      Task.new { |t| t.ignored = [Array, Hash] }
    end

    def test_loads_selected_lib_directories_in_the_load_path
      $:.expects(:unshift).with(File.join(Dir.pwd, "path"))
      Runner.expects(:run)
      Task.new { |t| t.libs << 'path' }
    end
    
    def test_accepts_custom_formatter
      Runner.expects(:run).with(:mocha, anything, :dot, anything)
      Task.new { |t| t.formatter = :dot }
    end
    
    def test_accepts_custom_formatter_output
      Runner.expects(:run).with(:mocha, anything, :dot, '/dev/null')
      Task.new { |t| t.formatter = :dot; t.formatter_out = '/dev/null' }
    end
  end
end