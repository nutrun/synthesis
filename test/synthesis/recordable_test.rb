require File.dirname(__FILE__) + "/helper"

module Synthesis
  class RecordableTest < Test::Unit::TestCase
    def test_redefines_method
      foo = Class.new { def a; end }
      foo.extend Recordable
      foo.recordable_method(:a)
      assert_respond_to(foo.new, :__recordable__a)
    end

    def test_records_method_invocation
      foo = Class.new { def b; end }
      foo.extend Recordable
      foo.recordable_method(:b)
      bar = foo.new
      MethodInvocationWatcher.expects(:invoked).with(bar, :b, [])
      bar.b
    end
    
    def test_does_not_redefine_already_redefined_method
      foo = Class.new { def b; end }
      foo.extend Recordable
      foo.stubs(:method_defined?).returns(true)
      foo.expects(:alias_method).never
      foo.recordable_method(:b)
    end
    
    def test_defines_non_existent_method
      foo = Class.new
      foo.extend Recordable
      foo.recordable_method(:bar)
      assert_respond_to(foo.new, :bar)
    end
    
    def test_defines_non_existent_method_recordable_placeholder_method
      foo = Class.new
      foo.extend Recordable
      foo.recordable_method(:bar)
      assert_respond_to(foo.new, :__recordable__bar)
    end
    
    def test_non_existed_method_placeholder_raises
      foo = Class.new
      foo.extend Recordable
      foo.recordable_method(:bar)
      assert_raise(RuntimeError) { foo.new.__recordable__bar }
    end
    
    def test_does_not_redefine_already_defined_magic_method
      foo = Class.new
      foo.extend Recordable
      foo.recordable_method(:b)
      foo.expects(:alias_method).never
    end
    
    def test_records_magic_method_invocation
      foo = Class.new {def method_missing(meth, *args) :magic! end}
      foo.extend Recordable
      foo.recordable_method(:b)
      bar = foo.new
      MethodInvocationWatcher.expects(:invoked).with(bar, :b, [])
      bar.b
    end
  end
end
