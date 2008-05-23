module Synthesis
  class MethodInvocationWatcher
    def self.invoked(receiver, method, args = [], return_values = [])
      matcher = Expectation.new(receiver, method, nil, args, return_values)
      ExpectationRecord[matcher].invoked!
    end
  end
end