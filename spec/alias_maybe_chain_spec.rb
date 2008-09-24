require File.dirname(__FILE__) + '/spec_helper'

describe "alias_method_chain" do
  before(:each) do
    # require statements go in here because of weirdnesses caused by other
    # specs run in this project.
    require 'active_support'
    require 'alias_maybe_chain.rb'
    @klass = Class.new { attr_accessor(:allowed); def foo; :foo end }
    @module = Module.new { def foo_with_fizz; [foo_without_fizz, :fizz] end }
    @object = @klass.new
  end
  
  it "should work without chaining" do
    @object.foo.should == :foo
  end
  
  it "should work as default" do
    @klass.send :include, @module
    @klass.alias_method_chain :foo, :fizz
    @object.foo.should == [:foo, :fizz]
  end
  
  describe "with conditionals" do
    before(:each) do
      @klass.send :include, @module
      @klass.alias_method_chain :foo, :fizz, :if => :allowed
    end
    
    it "should allow conditional support" do
      @object.foo.should == :foo
    end
 
    it "should be affected by conditional" do
      @object.foo.should == :foo
      @object.allowed = true
      @object.foo.should == [:foo, :fizz]
    end
 
    it "should let conditional toggle results" do
      @object.allowed = true
      @object.foo.should == [:foo, :fizz]
      @object.allowed = false
      @object.foo.should == :foo
    end
  end
  
  describe "with conditional as proc" do
    before(:each) do
      @allowed = false
      @klass.send :include, @module
      @klass.alias_method_chain :foo, :fizz, :if => proc { @allowed }
    end
    
    it "should still work" do
      @object.foo.should == :foo
      @allowed = true
      @object.foo.should == [:foo, :fizz]
    end
  end
end