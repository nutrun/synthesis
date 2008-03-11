class DataBrander
  BRAND = "METAL"
  
  def initialize(pstore)
    @pstore = pstore
  end
  
  def save_branded(data)
    @pstore.save "#{BRAND} - #{data}"
  end
end