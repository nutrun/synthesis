#!/usr/bin/env ruby
require "rake"
require "rake/tasklib"
require File.dirname(__FILE__) + "/../synthesis/logging"

module Synthesis
  class Task < Rake::TaskLib
    include Logging
    attr_accessor :verbose, :pattern, :ruby_opts
    attr_accessor :adapter, :out, :ignored, :libs, :formatter

    def initialize(name='synthesis:test')
      @name, @ignored, @libs = name, [], ['lib']
      yield self if block_given?
      @pattern ||= 'test/**/*_test.rb'
      @ruby_opts ||= []
      @adapter ||= :mocha
      @formatter ||= :text
      define
    end
    
    def ignore(*classes)
      STDERR.puts
      STDERR.puts "DEPRECATION WARNING!!!"
      STDERR.puts caller[0]
      STDERR.puts "Synthesis::Task#ignore(*classes) has been deprecated."
      STDERR.puts "Use Synthesis::Task#ignored = [#{classes * ','}] instead."
      STDERR.puts
      @ignored << classes
      @ignored.flatten!
    end

    def define
      desc "Run Synthesis tests"
      task @name do
        RakeFileUtils.verbose(@verbose) do
          load_paths
          require File.dirname(__FILE__) + "/../synthesis"
          require File.dirname(__FILE__) + "/../synthesis/runner"
          Synthesis::Logging.const_set(:OUT, @out) if @out
          Synthesis::ExpectationRecord.ignore(*@ignored)
          Synthesis::Runner.run(@adapter, @pattern, @formatter)
        end
      end
      self
    end

    private 
    def load_paths
      @libs.each { |path| $:.unshift(File.join(Dir.pwd, path)) }
    end
  end
end
