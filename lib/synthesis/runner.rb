module Synthesis
  class Runner
    def self.run(adapter, pattern)
      require "synthesis/adapter/#{adapter}"
      Adapter.load(pattern).run
    end    
  end
end

at_exit { exit Synthesis.report! unless $! }