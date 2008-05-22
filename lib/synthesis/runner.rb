module Synthesis
  class Runner
    def self.run(adapter, pattern, format = :plain)
      require "synthesis/adapter/#{adapter}"
      require "synthesis/formatter/#{format}_formatter"
      Adapter.load(pattern).run
      exit Reporter.report unless $!
    end    
  end
end
