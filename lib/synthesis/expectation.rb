module Synthesis
  module Expectation
    #FIXME: make return values a Set
    def self.new(receiver, method, track, args = [], return_values = [])
      receiver.expectation(method, track, args, return_values)
    end
  
    class Expectation
      include Logging
      attr_reader :receiver, :method
      attr_accessor :args
      
      def initialize(receiver, method, track, args, return_values)
        @receiver, @method, @track, @args = receiver, method, track, args
        @return_values = return_values
      end
      
      def record_invocations
        meta_receiver.extend(Recordable)
        meta_receiver.recordable_method(@method)
      end
      
      def eql?(other)
        ExpectationMatcher.new(self, other).match?
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
      
      def arg_types
        args.map { |arg| arg.class }
      end
      
      def return_value_types
        @return_values.map { |val| val.class }
      end
      
      def add_return_values(*vals)
        @return_values += vals
      end
    end
  
    class Singleton < Expectation
      def meta_receiver
        @receiver.__metaclass__
      end
      
      def hash
        (@receiver.name.hash * 23) + @method.hash
      end
      
      def receiver_class
        @receiver
      end
      
      def to_s
        "(#{return_values.class})#{@receiver.name}.#{@method}(#{@args.map { |arg| arg.class } * ', '}) in #{@track}"
      end
    end
    
    class Instance < Expectation
      def meta_receiver
        @receiver.class
      end
      
      def hash
        (meta_receiver.name.hash * 23) + @method.hash
      end
      
      def receiver_class
        meta_receiver
      end
      
      def to_s
        "(#{return_values.class})#{meta_receiver.name}.new.#{@method}(#{@args.map { |arg| arg.class } * ', '}) in #{@track}"
      end
    end
    
    class NilExpectation < Expectation
      def initialize;end
      def invoked!;end
      def record_invocations;end
    end
  end
end
