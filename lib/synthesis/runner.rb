module Synthesis
  class Runner
    def self.run(adapter, pattern)
      require "synthesis/adapter/#{adapter}"
      Adapter.load(pattern).run
      exit Synthesis::Reporter.report unless $!
    end    
  end
end
