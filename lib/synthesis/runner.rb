module Synthesis
  class Runner
    def self.run(adapter, pattern, formatter)
      require "synthesis/adapter/#{adapter}"
      require "synthesis/formatter/#{formatter}"
      Adapter.load(pattern).run
      exit Reporter.report unless $!
    end    
  end
end
