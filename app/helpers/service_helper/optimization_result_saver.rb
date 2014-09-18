class ServiceHelper::OptimizationResultSaver
  attr_reader :result_type, :name, :output_model, :user_id
  def initialize(result_type = nil, name = nil, user_id = 0)
    @result_type = result_type || 'optimization_results'
    @name = name || 'default_output_results_name'
    @user_id = user_id
    @output_model = Customer::Stat.where(:result_type => @result_type).where(:result_name => @name, :user_id => @user_id)
  end
  
  def clean_output_results
    output_model.delete_all
  end
  
  def save(output)
    where_hash = {:operator_id => output[:operator], :tarif_id => output[:tarif], :accounting_period => output[:accounting_period]} if output
    model_to_save = output_model.where(where_hash)
    result = if model_to_save.exists?
      merged_output = results ? {:result => results.merge(output[:result])} : output
      model_to_save.update_all(merged_output)    
    else
      model_to_save.create    
      model_to_save.update_all(output)    
    end    
    result
  end
  
  def override(output)
    where_hash = {:operator_id => output[:operator], :tarif_id => output[:tarif], :accounting_period => output[:accounting_period]} if output
    model_to_save = output_model.where(where_hash)
    if model_to_save.exists?
      model_to_save.update_all(output)    
    else
      model_to_save.create    
      model_to_save.update_all(output)    
    end        
  end
  
  def results(where_hash = {})
    result = output_model.where(where_hash).select("result as #{name}").first
    result.attributes[name] if result
  end

end
