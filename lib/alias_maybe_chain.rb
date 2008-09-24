class Module
  module ConditionalEvaluator
    def evaluate_conditional(conditional)
      case conditional
      when Symbol then send(conditional)
      when Proc then conditional.call
      else
        false
      end
    end
  end
  
  def alias_method_chain_with_conditional(target, feature, options={})
    include ConditionalEvaluator unless included_modules.include?(ConditionalEvaluator)
    
    return alias_method_chain_without_conditional(target, feature) unless options[:if]
    
    define_method("#{target}_with_#{feature}_with_conditional") do |*args|
      return send("#{target}_without_#{feature}", *args) unless evaluate_conditional(options[:if])
      send("#{target}_with_#{feature}_without_conditional", *args)
    end
    
    alias_method_chain("#{target}_with_#{feature}", :conditional)
    alias_method_chain_without_conditional(target, feature)
  end
  alias_method_chain :alias_method_chain, :conditional
end