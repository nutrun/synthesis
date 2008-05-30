require 'rubygems'
require 'sexp_processor'

module Synthesis
  class DotProcessor < SexpProcessor
    def self.process(exp, method)
      analyzer = self.new
      analyzer.method = method
      analyzer.process(exp)
      analyzer.klazz
    end
    
    attr_accessor :method
    attr_reader :klazz

    def initialize
      super
      self.strict = false
      self.auto_shift_type = true
      @ancestors = []
    end
    
    def process_module(exp)
      name = exp.shift
      @ancestors << name
      s(:module, name, process(exp.shift))
    end
    
    def process_class(exp)
      name = exp.shift
      @ancestors << name
      s(:class, name, exp.shift, process(exp.shift))
    end
    
    def process_defn(exp)
      name = exp.shift
      if name == method.to_sym
        @klazz = @ancestors * '::'
      end
      s(:defn, name, process(exp.shift), process(exp.shift))
    end
  end  
end
