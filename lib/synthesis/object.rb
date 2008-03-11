class Object
  def __metaclass__
    class << self; self end
  end
  
  def expectation(method, track, args = [])
    Synthesis::Expectation::Instance.new(self, method, track, args)
  end
end