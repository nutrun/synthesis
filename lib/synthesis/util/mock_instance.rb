if defined? Mocha
  require File.dirname(__FILE__) + "/mock_instance/mocha"
elsif defined? Spec
  require File.dirname(__FILE__) + "/mock_instance/rspec"
else
  raise "Either mocha_standalone or spec/mocks must be required before you can use mock_instance"
end