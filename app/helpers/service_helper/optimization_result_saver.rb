class ServiceHelper::OptimizationResultSaver
  attr_reader :name, :output_model
  def initialize(name = nil)
    @name = name || 'default_output_results_name'
    @output_model = Customer::Stat.where(:result_type => 'optimization_results').where(:result_name => @name)
  end
  
  def clean_output_results
    output_model.delete_all
  end
  
  def save(output)
    where_hash = {:operator_id => output[:operator], :tarif_id => output[:tarif]} if output
    model_to_save = output_model.where(where_hash)
    result = if model_to_save.exists?
#     raise(StandardError, [results.keys, output.keys])
      merged_output = results ? {:result => results.merge(output[:result])} : output
      model_to_save.first.update_attributes!(merged_output)    
    else
      model_to_save.create({:result_type => 'optimization_results', :result_name => name}.merge(output) )    
    end    
    result
  end
  
  def results
    result = output_model.select("result as #{name}").first
    result.attributes[name] if result
  end
end
