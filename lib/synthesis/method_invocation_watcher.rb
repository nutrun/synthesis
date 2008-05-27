module Synthesis
  class MethodInvocationWatcher
    def self.invoked(receiver, method, args = [], return_values = [])
      cal = caller.clone
      path_from_spec = []
      begin
        c = cal.shift
        path_from_spec.unshift c unless c =~ /(\(eval\)|gems)/
      end until c =~ /(spec|test)/
      matcher = Expectation.new(receiver, method, nil, args, return_values)
      ExpectationRecord[matcher].invoked! path_from_spec
    end
  end
end