class DataBrander
  BRAND = "METAL"
  
  def initialize(storage)
    @storage = storage
  end
  
  def save_branded(data)
    @storage.save "#{BRAND} - #{data}"
  end
  
  def dont_do_this
    @storage.ouch!
  end
end

class Storage
  def initialize(filename)
    @filename = filename
  end
  
  def save(val)
    File.open(@filename, 'w') {|f| f << val}
  end
  
  def ouch!
    raise Problem
  end
end

class Problem < Exception;end
