class Module
  def expectation(method, track, args = [], return_value = nil)
    Synthesis::Expectation::Singleton.new(self, method, track, args, return_value)
  end
end