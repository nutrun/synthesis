module Synthesis
  class DotFormatter < Formatter
    def initialize
      Expectation::Expectation.send(:include, ExpectationReportFormat::Dot)
    end
    
    def format_digraph
      format_header
      puts "  edge [color = green]"
      ExpectationRecord.tested_expectations.each { |exp| exp.to_report  }
      puts
      puts "  edge [color = red]"
      ExpectationRecord.untested_expectations.each  { |exp| exp.to_report  }
      format_footer
    end
    alias format_failure format_digraph
    alias format_success format_digraph
    
    private
    def format_header
      puts "digraph synthesis_expectations {"
      puts "  rankdir=LR;"
      puts "  size=\"8,10\";"
      puts "  ratio=\"fill\";"
      puts "  node [shape = circle];"
    end
    
    def format_footer
      puts "}"
    end
  end
end