module Synthesis
  class MethodInvocationWatcher
    def self.invoked(receiver, method, args = [], return_values = [])
      
      source = caller[1].split(':')
      matcher = Expectation.new(receiver, method, nil, args, return_values)
      ExpectationRecord[matcher].invoked! source[0]
    end
  end
end