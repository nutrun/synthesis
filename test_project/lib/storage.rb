class Storage
  def initialize(filename)
    @filename = filename
  end
  
  def save(val)
    File.open(@filename, 'w') {|f| f << val}
  end
end