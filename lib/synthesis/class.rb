class Class
  def expectation(method, track, args = [])
    Synthesis::Expectation::Singleton.new(self, method, track, args)
  end
end