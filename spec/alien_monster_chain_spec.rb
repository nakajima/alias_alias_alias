require File.dirname(__FILE__) + '/spec_helper'
require 'alien_monster_chain'

describe "alien_monster_chain" do
  before(:each) do
    @klass = Class.new do
      def foo; :foo end
    end
  end

  it "should not change anything if no new alias is defined" do
    @klass.class_eval do
      alien_monster_chain :foo
    end
    @klass.new.foo.should == :foo
  end
  
  it "should add behavior to method" do
    @klass.class_eval do
      alien_monster_chain(:foo) { :bar }
    end
    
    @klass.new.foo.should == :bar
  end

  it "should allow super to be called for non-aliased behavior" do
    @klass.class_eval do
      alien_monster_chain(:foo) { [super, :bar] }
    end
    
    @klass.new.foo.should == [:foo, :bar]
  end
  
  it "should be overridden twice" do
    @klass.class_eval do
      alien_monster_chain(:foo) { [super, :two] }
      alien_monster_chain(:foo) { [super, :three] }
    end
    
    @klass.new.foo.should == [[:foo, :two], :three]
  end
  
  it "should define 'without' method" do
    @klass.class_eval do
      alien_monster_chain(:foo, :bar) { [foo_without_bar, :bar] }
    end
    
    @klass.new.foo.should == [:foo, :bar]
  end

  it "should allow for methods with blocks" do
    klass = Class.new do
      def with_foo(&block)
        yield :foo
      end
      
      alien_monster_chain :with_foo do
        [super { |a| a }, :bar]
      end
    end
    
    klass.new.with_foo { :bar }.should == [:foo, :bar]
  end
  
end
