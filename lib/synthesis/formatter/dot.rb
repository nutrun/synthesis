require 'rubygems'
require 'parse_tree'
require 'sexp'
require File.dirname(__FILE__) + '/dot_processor'

module Synthesis
  class DotFormatter < Formatter
    def format_digraph
      format_header
      puts "  edge [color = green]"
      ExpectationRecord.tested_expectations.each { |exp| plot_expectation(exp)  }
      # puts
      # puts "  edge [color = blue]"
      # ExpectationRecord.tested_expectations.each  { |exp| plot_expected_interaction(exp)  }
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
      puts "  size=\"8,10\";"
      puts "  ratio=\"fill\";"
      puts "  node [shape = circle];"
    end
    
    def format_footer
      puts "}"
    end
    
    def label_for(expectation)
      "(#{expectation.return_value_type}) " +
      "#{expectation.method}(#{expectation.args.map { |arg| arg.class } * ', '})"
    end
    
    # def plot_actual_interaction(expectation)
    #   if path_to_spec = expectation.caller
    #     complete_at = path_to_spec.size - 1
    #     path_to_spec.each_with_index do |file, idx|
    #       from, from_line = file.split(':')
    #       if idx == complete_at
    #         puts "  \"#{from}\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
    #       else
    #         to, to_line = path_to_spec[idx+1].split(':')
    #         puts "  \"#{from}\" -> \"#{to}\" [ label = \"#{from_line} -> #{to_line}\" ];"
    #       end
    #     end
    #   else
    #     puts "  \"?\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
    #   end
    # end
    # 
    def plot_expectation(expectation)
      if expectation.test_subject
        filename, line, method = expectation.test_subject[1].split(':')
        begin
          method = method.scan(/`(.*)'/)[0][0]
          ruby = File.read(filename)
          parser = ParseTree.new
          sexp = parser.parse_tree_for_string(ruby, filename).first
          sexp = Sexp.from_array sexp
          test_subject = DotProcessor.process(sexp, method)
        rescue
          test_subject = filename
        end
      else
        test_subject = "?"
      end
      puts "  \"#{test_subject}\" -> \"#{expectation.receiver_class}\" [ label = \"#{label_for(expectation)}\" ];"
    end
  end
end