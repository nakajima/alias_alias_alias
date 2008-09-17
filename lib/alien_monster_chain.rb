require 'rubygems' unless defined?(Gem)
require 'rebound'

class Module
  def alien_monster_chain(target, monster=nil, &block)
    return unless block_given?
    original = instance_method(target)
    define_method("#{target}_without_#{monster}", original) if monster
    include Module.new { eval(original.to_s(:ruby)) }
    define_method(target, &block)
  end
end