require "parse_tree"
require "sexp"
require "sexp_processor"

module Synthesis
  class DotFormatter < Formatter
    def initialize(out)
      super
      Expectation::Expectation.send(:include, ExpectationReportFormat::Dot)
    end
    
    def digraph
      @out.puts "digraph synthesis_expectations {"
      @out.puts "  rankdir=LR;"
      @out.puts "  size=\"10,10\";"
      @out.puts "  ratio=\"fill\";"
      @out.puts "  remincross=\"true\";"
      @out.puts "  node [shape = circle];"
      @out.puts "  edge [color = green]"
      report_tested_expectations
      @out.puts
      @out.puts "  edge [color = red]"
      report_untested_expectations
      @out.puts "}"
    end
    alias format_failure digraph
    alias format_success digraph
  end
  
  module ExpectationReportFormat
    module Dot
      def to_report
        "  \"#{test_subject_name}\" -> \"#{receiver_class}\" " +
        "[ label = \"(#{return_value_type}) #{method}(#{arg_types * ', '})\" ];"
      end
          
      private
    
      def test_subject_name
        filename, line, method = test_subject[1].split(':')
        method = method.scan(/`(.*)'/)[0][0]
        ruby = File.read(filename)
        parser = ParseTree.new
        sexp = parser.parse_tree_for_string(ruby, filename).first
        sexp = Sexp.from_array(sexp)
        return DotProcessor.process(sexp, method)
      rescue
        filename ? "#{filename} (#{line})" : "?"
      end

      class DotProcessor < SexpProcessor
        attr_accessor :method
        attr_reader :klazz

        def self.process(exp, method)
          analyzer = self.new
          analyzer.method = method
          analyzer.process(exp)
          analyzer.klazz
        end

        def initialize
          super
          self.strict = false
          self.auto_shift_type = true
          @ancestors = []
        end

        def process_module(exp)
          name = exp.shift
          @ancestors.push name
          result = s(:module, name, process(exp.shift))
          @ancestors.pop
          result
        end

        def process_class(exp)
          name = exp.shift
          @ancestors.push name
          result = s(:class, name, exp.shift, process(exp.shift))
          @ancestors.pop
          result
        end

        def process_defn(exp)
          name = exp.shift
          @klazz = @ancestors * '::' if name == method.to_sym
          s(:defn, name, process(exp.shift))
        end

        def process_defs(exp)
          selff = exp.shift
          name = exp.shift
          @klazz = @ancestors * '::' if name == method.to_sym
          s(:defs, selff, name, process(exp.shift))
        end
      end
    end
  end
end