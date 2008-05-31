require "parse_tree"
require "sexp"
require "sexp_processor"

module Synthesis
  class DotFormatter < Formatter
    def initialize
      Expectation::Expectation.send(:include, ExpectationReportFormat::Dot)
    end
    
    def graph
      puts "digraph synthesis_expectations {"
      puts "  rankdir=LR;"
      puts "  size=\"8,10\";"
      puts "  ratio=\"fill\";"
      puts "  node [shape = circle];"
      puts "  edge [color = green]"
      ExpectationRecord.tested_expectations.each { |exp| puts exp.to_report  }
      puts
      puts "  edge [color = red]"
      ExpectationRecord.untested_expectations.each  { |exp| puts exp.to_report  }
      puts "}"
    end
    alias format_failure graph
    alias format_success graph
  end
  
  module ExpectationReportFormat
    module Dot
      def to_report
        "  \"#{test_subject_name}\" -> " +
        "\"#{receiver_class}\" " +
        "[ label = " +
        "\"(#{return_value_type}) " +
        "#{method}(#{args.map { |arg| arg.class } * ', '})\" ];"
      end
          
      private
    
      def test_subject_name
        if test_subject
          filename, line, method = test_subject[1].split(':')
          begin
            method = method.scan(/`(.*)'/)[0][0]
            ruby = File.read(filename)
            parser = ParseTree.new
            sexp = parser.parse_tree_for_string(ruby, filename).first
            sexp = Sexp.from_array(sexp)
            return DotProcessor.process(sexp, method)
          rescue
            return filename
          end
        else
          return "?"
        end
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
  end
end