module Synthesis
  class DotFormatter < Formatter
    def format_digraph
      format_header
      puts "  edge [color = green]"
      ExpectationRecord.tested_expectations.each { |exp| plot_actual_interaction(exp)  }
      puts
      puts "  edge [color = blue]"
      ExpectationRecord.tested_expectations.each  { |exp| plot_expected_interaction(exp)  }
      puts
      puts "  edge [color = red]"
      ExpectationRecord.untested_expectations.each  { |exp| plot_actual_interaction(exp)  }
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
    
    def plot_actual_interaction(expectation)
      if path_to_spec = expectation.caller
        complete_at = path_to_spec.size - 1
        path_to_spec.each_with_index do |file, idx|
          from, from_line = file.split(':')
          if idx == complete_at
            puts "  \"#{from}\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
          else
            to, to_line = path_to_spec[idx+1].split(':')
            puts "  \"#{from}\" -> \"#{to}\" [ label = \"#{from_line} -> #{to_line}\" ];"
          end
        end
      else
        puts "  \"?\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
      end
    end
    
    def plot_expected_interaction(expectation)
      test_subject = expectation.test_subject.split(':')[0]
      puts "  \"#{test_subject}\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
    end
  end
end