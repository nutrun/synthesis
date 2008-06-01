module Synthesis
  module Expectation
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
      
      def add_test_subject(test_subject)
        (@callers ||= []) << test_subject
      end
      
      def test_subject
        @callers[0]
      end
      
      def explode
        if @return_values.size > 1
          @return_values.map do |v|
            expectation = self.class.new(@receiver, @method, @track, @args, [])
            expectation.add_test_subject @callers.shift
            expectation.add_return_values(v)
            expectation
          end
        else
          self
        end
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
      
      def return_value_type
        @return_values[0].class
      end
      
      def add_return_values(*vals)
        @return_values_defined = true
        @return_values += vals
      end
      
      def return_values_defined?
        @return_values_defined
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
      
      def receiver_repr
        @receiver.name
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
      
      def receiver_repr
        "#{meta_receiver.name}.new"
      end      
    end
    
    class NilExpectation < Expectation
      def initialize;end
      def invoked!;end
      def record_invocations;end
    end
  end
end
