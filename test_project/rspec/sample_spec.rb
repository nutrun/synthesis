%w(rubygems spec).each { |l| require l }

module Source
  class First
    def initialize(storage)
      @storage = storage
    end
  
    def do_once(data)
      @storage.save "#{data}"
    end
  end

  class Second
    def initialize(storage)
      @storage = storage
    end
  
    def do_again(data)
      @storage.save "#{data}"
    end
  end
end

class Target
  def save(data)
    return false if @called
    @called = true
  end
end

describe "Scenarios for testing the dot reportter" do
  it "should record consecutive returns from different sources" do
    pstore = Target.new
    pstore.should_receive(:save).with('rock').and_return(true, false)

    source = Source::First.new(pstore)
    source.do_once('rock').should be_true
    
    source = Source::Second.new(pstore)
    source.do_again('rock').should be_false
  end
  
  it "should cover target with unit test" do
    target = Target.new
    target.save('rock').should be_true
    target.save('rock').should be_false
  end
end