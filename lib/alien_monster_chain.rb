require 'rubygems' unless defined?(Gem)
require 'rebound'

class Module
  # Totally irresponsible variation on alias_method_chain.
  #
  # USAGE
  #
  # class Klass
  #   def foo
  #     :foo
  #   end
  # end
  #
  # Klass.alien_monster_chain :foo do
  #   [super, :bar]
  # end
  #
  # or
  # 
  # Klass.alien_monster_chain :foo, :ufo do
  #   [foo_without_ufo, :bar]
  # end
  #
  # Klass.new.foo # => [:foo, :bar]
  def alien_monster_chain(target, monster=nil, &block)
    return unless block_given?
    original = instance_method(target)
    define_method("#{target}_without_#{monster}", original) if monster
    include Module.new { module_eval(original.to_s(:ruby)) }
    define_method(target, &block)
  end
end
