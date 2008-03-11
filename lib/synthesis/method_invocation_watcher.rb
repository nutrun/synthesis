module Synthesis
  class MethodInvocationWatcher
    def self.invoked(receiver, method, args = [])
      matcher = Expectation.new(receiver, method, nil, args)
      ExpectationRecord[matcher].invoked!
    end
  end
end