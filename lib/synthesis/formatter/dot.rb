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
end