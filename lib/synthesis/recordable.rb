module Synthesis
  module Recordable
    def recordable_method(meth)
      if method_defined?(meth)
        defined_recordable_method(meth)
      else
        magic_recordable_method(meth)
      end
    end
    
    protected
    
    def defined_recordable_method(meth)
      unless method_defined?("__recordable__#{meth}".intern)
        alias_method "__recordable__#{meth}".intern, meth
        class_eval @@recordable_method_def[meth]
      end
    end
      
    @@recordable_method_def = proc { |meth| %(
      def #{meth}(*args, &block)
        MethodInvocationWatcher.invoked(self, "#{meth}".intern, args)
        send "__recordable__#{meth}", *args, &block
      end
    )}
    
    def magic_recordable_method(meth)
      class_eval @@recordable_magic_method_def[meth]
    end
      
    @@recordable_magic_method_def = proc { |meth| %(
      def #{meth}(*args)
        MethodInvocationWatcher.invoked(self, "#{meth}".intern, args)
        method_missing(:#{meth}, *args)
      end
      
      def __recordable__#{meth}() raise "Don't ever call me" end
    )}
  end
end
