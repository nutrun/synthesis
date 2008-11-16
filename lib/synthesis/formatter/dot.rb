begin
  require "parse_tree"
	require "sexp"
	require "sexp_processor"
rescue LoadError
  puts "Dot formatter depends on the sexp_processor and ParseTree libraries"
  exit 1
end

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
        # Skip 3 to avoid mock proxies
        klass, meth, filename, line, lang = *test_subject[3]
        klass.to_s =~ /^#<Class:(.*)>$/ ? $1 : klass.to_s
      rescue
        filename ? "#{filename} (#{line})" : "?"
      end
    end
  end
end