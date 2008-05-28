class DataBrander
  BRAND = "METAL"
  
  def initialize(pstore)
    @pstore = pstore
  end
  
  def save_branded(data)
    @pstore.save "#{BRAND} - #{data}"
  end
end

class Storage
  def initialize(filename)
    @filename = filename
  end
  
  def save(val)
    File.open(@filename, 'w') {|f| f << val}
  end
end
