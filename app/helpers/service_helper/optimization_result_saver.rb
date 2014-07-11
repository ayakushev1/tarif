class ServiceHelper::OptimizationResultSaver
  attr_reader :name, :output_model
  def initialize(name = nil)
    @name = name || 'default_output_results_name'
    @output_model = Customer::Stat.where("(result->'#{@name}') is not null")
  end
  
  def clean_output_results
    output_model.delete_all
  end
  
  def save(output)
    result = if output_model.exists?
      merged_output = results ? results.merge(output) : output
      output_model.update_all({:result => {name => merged_output } }, "(result->'#{@name}') is not null" )    
#      output_model.update_attributes!({:result => {name => merged_output } } )    
    else
      output_model.create({:result => {name => output} } )    
    end    
#    raise(StandardError, results.keys)
    result
  end
  
  def results
    result = output_model.select("result->'#{name}' as #{name}").first
#    raise(StandardError, result.attributes[name].keys) if result
#    result
    result.attributes[name] if result
  end
end
