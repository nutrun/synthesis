module Synthesis
  class Runner
    def self.run(adapter, pattern, formatter, formatter_out)
      begin
        require "synthesis/adapter/#{adapter}"
      rescue LoadError
        raise "Invalid adapter: #{adapter}"
      end
      Adapter.load(pattern).run
      at_exit { exit Reporter.report(formatter, formatter_out) unless $! }
    end    
  end
end
