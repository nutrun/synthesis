module Synthesis
  class Reporter
    def self.report(format, formatter_out)
      begin
        require "synthesis/formatter/#{format}"
      rescue LoadError
        raise "Invalid format: #{format}"
      end
      out = formatter_out ? File.open(formatter_out, 'w') : STDOUT
      result = 0
      begin
        formatter = Formatter.load(out)
        if ExpectationRecord.has_untested_expectations?
          formatter.format_failure
          result = -1
        else
          formatter.format_success
        end
      ensure
        out.close unless out == STDOUT
      end
      return result
    end
  end
end