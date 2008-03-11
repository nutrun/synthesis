#!/usr/bin/env ruby
require 'rake'
require 'rake/tasklib'

module Synthesis
  class Task < Rake::TaskLib
    attr_accessor :verbose, :pattern, :ruby_opts, :adapter, :out

    def initialize(name='synthesis:test')
      @name, @ignored = name, []
      yield self if block_given?
      @pattern ||= 'test/**/*.rb'
      @ruby_opts ||= []
      @adapter ||= :mocha
      define
    end
    
    def ignore(*classes)
      @ignored << classes
      @ignored.flatten!
    end

    def define
      desc "Run Synthesis tests"
      task @name do
        RakeFileUtils.verbose(@verbose) do
          @ruby_opts.unshift("-w") if @warning
          require File.dirname(__FILE__) + "/../synthesis"
          require File.dirname(__FILE__) + "/../synthesis/runner"
          Synthesis::Logging.const_set(:OUT, @out) if @out
          Synthesis::ExpectationRecord.ignore(*@ignored)
          Synthesis::Runner.run(@adapter, @pattern)
        end
      end
      self
    end
  end
end
