module Synthesis
  module Logging
    def silence!
      @silent = true
    end
    
    def speak!
      @silent = false
    end
    
    protected

    def log(msg = '')
      out.puts "[Synthesis] #{msg}" unless @silent
    end
    
    def puts(msg = '')
      out.puts "#{msg}" unless @silent
    end
    
    def out
      Synthesis::Logging.const_defined?(:OUT) ? OUT : STDOUT
    end
  end
end
