module Synthesis
  module Recordable
    def recordable_method(meth)
      if method_defined?(meth) || private_method_defined?(meth)
        defined_recordable_method(meth)
      else
        magic_recordable_method(meth)
      end
    end
    
    protected
    
    def defined_recordable_method(meth)
      unless method_defined?("__recordable__#{meth}".intern)
        alias_method "__recordable__#{meth}".intern, meth
        class_eval <<-end_eval
          def #{meth}(*args, &block)
            begin
              return_value = send("__recordable__#{meth}", *args, &block)
              MethodInvocationWatcher.invoked(self, "#{meth}".intern, args, [return_value])
              return_value
            rescue Exception => e
              MethodInvocationWatcher.invoked(self, "#{meth}".intern, args, [e])
              raise e
            end
          end
        end_eval
      end
    end
      
    def magic_recordable_method(meth)
      class_eval <<-end_eval
        def #{meth}(*args)
          begin
            return_value = method_missing(:#{meth}, *args)
            MethodInvocationWatcher.invoked(self, "#{meth}".intern, args, [return_value])
            return_value
          rescue Exception => e
            MethodInvocationWatcher.invoked(self, "#{meth}".intern, args, [e])
            raise e
          end
        end

        def __recordable__#{meth}() raise "Don't ever call me" end
      end_eval
    end
  end
end
