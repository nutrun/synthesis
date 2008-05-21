class Object
  def self.mock_instance(*args)
    class_eval do
      alias original_initialize initialize
      def initialize()end
    end

    instance = new
    expects(:new).with(*args).returns(instance)

    class_eval do
      alias initialize original_initialize
      undef original_initialize
    end

    return instance
  end
end