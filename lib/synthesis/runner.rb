module Synthesis
  class Runner
    def self.run(adapter, pattern, format = :plain)
      require "synthesis/adapter/#{adapter}"
      Adapter.load(pattern).run
      exit Reporter.report(format) unless $!
    end    
  end
end
