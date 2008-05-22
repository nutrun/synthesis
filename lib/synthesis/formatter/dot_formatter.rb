module Synthesis
  class DotFormatter < Formatter
    include Logging
    def format_digraph
      format_header
      puts "  edge [color = green]"
      ExpectationRecord.tested_expectations.each do |exp|
        puts "  \"#{exp.caller}\" -> \"#{exp.receiver_class}\" [ label = \"#{label_for(exp)}\" ];"
      end
      puts
      puts "  edge [color = red]"
      ExpectationRecord.untested_expectations.each do |exp|
        puts "  \"?\" -> \"#{exp.receiver_class}\" [ label = \"#{label_for(exp)}\" ];"
      end
      format_footer
    end
    alias format_failure format_digraph
    alias format_success format_digraph
    
    private
    def format_header
      puts "digraph synthesis_expectations {"
      puts "  rankdir=LR;"
      puts "  size=\"8,5\";"
      puts "  node [shape = circle];"
    end
    
    def format_footer
      puts "}"
    end
    
    def label_for(expectation)
      "(#{expectation.return_value_types * ", "}) " +
      "#{expectation.method}(#{expectation.args.map { |arg| arg.class } * ', '})"
    end
  end
end