module Synthesis
  module Expectation
    def self.new(receiver, method, track, args = [], return_value = nil)
      receiver.expectation(method, track, args, return_value)
    end
  
    class Expectation
      include Logging
      attr_reader :receiver, :method
      attr_accessor :args, :return_value
      
      def initialize(receiver, method, track, args, return_value)
        @receiver, @method, @track, @args = receiver, method, track, args
        @return_value = return_value
      end
      
      def record_invocations
        meta_receiver.extend Recordable
        meta_receiver.recordable_method @method
      end
      
      def ==(other)
        eql?(other)
      end
      
      def invoked?
        @invoked
      end
      
      def invoked!
        @invoked = true
      end
      
      protected
      
      def args_match?(other)
        self.args.map { |arg| arg.class } == other.args.map { |arg| arg.class }
      end
    end
  
    class Singleton < Expectation
      def meta_receiver
        @receiver.__metaclass__
      end
      
      def eql?(other)
        return false unless other.is_a?(Synthesis::Expectation::Singleton)
        @receiver.name == other.receiver.name && 
        @method == other.method &&
        return_value.class == other.return_value.class &&
        args_match?(other)
      end
      
      def hash
        (@receiver.name.hash * 23) + @method.hash
      end
      
      def to_s
        "(#{return_value.class})#{@receiver.name}.#{@method}(#{@args.map { |arg| arg.class } * ', '}) in #{@track}"
      end
    end
    
    class Instance < Expectation
      def meta_receiver
        @receiver.class
      end
      
      def eql?(other)
        return false unless other.is_a?(Synthesis::Expectation::Instance)
        meta_receiver.name == other.meta_receiver.name && 
        @method == other.method &&
        return_value.class == other.return_value.class &&
        args_match?(other)
      end
      
      def hash
        (meta_receiver.name.hash * 23) + @method.hash
      end
      
      def to_s
        "(#{return_value.class})#{meta_receiver.name}.new.#{@method}(#{@args.map { |arg| arg.class } * ', '}) in #{@track}"
      end
    end
    
    class NilExpectation < Expectation
      def initialize;end
      def invoked!;end
      def record_invocations;end
    end
  end
end
