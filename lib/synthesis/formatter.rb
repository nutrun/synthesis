module Synthesis
  class Formatter
    class << self
      def load
        @formatter.new
      end
    
      def inherited(subclass)
        @formatter = subclass
      end
    end
  end
end