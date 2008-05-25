module Synthesis
  class DotFormatter < Formatter
    def format_digraph
      format_header
      puts "  edge [color = green]"
      ExpectationRecord.tested_expectations.each { |exp| plot_expectation(exp)  }
      puts
      puts "  edge [color = red]"
      ExpectationRecord.untested_expectations.each  { |exp| plot_expectation(exp)  }
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
    
    def plot_expectation(expectation)
      if path_to_spec = expectation.caller
        complete_at = path_to_spec.size - 1
        path_to_spec.each_with_index do |file, idx|
          caller = file.split(':')[0]
          if idx == complete_at
            puts "  \"#{caller}\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
          else
            puts "  \"#{caller}\" -> \"#{path_to_spec[idx+1].split(':')[0]}\";"
          end
        end
      else
        puts "  \"?\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
      end
    end
  end
end