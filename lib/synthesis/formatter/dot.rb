require "parse_tree"
require "sexp"
require "sexp_processor"

module Synthesis
  class DotFormatter < Formatter
    def initialize
      Expectation::Expectation.send(:include, ExpectationReportFormat::Dot)
    end
    
    def digraph
      puts "digraph synthesis_expectations {"
      puts "  rankdir=LR;"
      puts "  size=\"8,10\";"
      puts "  ratio=\"fill\";"
      puts "  node [shape = circle];"
      puts "  edge [color = green]"
      report_tested_expectations
      puts
      puts "  edge [color = red]"
      report_untested_expectations
      puts "}"
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
        return "#{filename} (#{line})"
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
          s(:defn, name, process(exp.shift), process(exp.shift))
        end
      end
    end
  end
end