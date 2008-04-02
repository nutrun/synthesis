class Object
  def __metaclass__
    class << self; self end
  end
  
  def expectation(method, track, args = [], return_value = nil)
    Synthesis::Expectation::Instance.new(self, method, track, args, return_value)
  end
end