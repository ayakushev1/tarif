class Customer::Stat::OptimizationResult #ServiceHelper::OptimizationResultSaver
  
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
    where_hash = where_hash_from_output(output)
    model_to_save = output_model.where(where_hash)
#    raise(StandardError) if model_to_save.count > 1
    merged_output = results ? {:result => results.merge(output[:result])} : output
    model_to_save.create! if !model_to_save.exists?

    number_of_efforts_to_save = 10
    i = 0
    begin
#      sleep(0.1) 
      number_of_updated_rows = model_to_save.update_all(merged_output)
      i += 1
    end while number_of_updated_rows == 0 and i < number_of_efforts_to_save
      
    raise(StandardError, "sql cannot update records, sql = #{model_to_save.to_sql}") if number_of_updated_rows == 0

    number_of_updated_rows
  end
  
  def override(output)
    where_hash = where_hash_from_output(output)
    model_to_save = output_model.where(where_hash)
    model_to_save.create! if !model_to_save.exists?

#    raise(StandardError) if (!output[:operator_id] and output[:operator]) or (!output[:tarif_id] and output[:tarif])
    
    number_of_efforts_to_save = 10
    i = 0
    begin 
#      sleep(0.1) 
      number_of_updated_rows = model_to_save.update_all(output)
      i += 1
    end while number_of_updated_rows == 0 and i < number_of_efforts_to_save
      
    raise(StandardError, "sql cannot update records, sql = #{model_to_save.to_sql} output #{output}") if number_of_updated_rows == 0
  end
  
  def where_hash_from_output(output)
    where_hash = {}
    if output
      where_hash.merge!({:operator_id => output[:operator_id]}) #if output[:operator]
      where_hash.merge!({:tarif_id => output[:tarif_id]}) #if output[:tarif]
      where_hash.merge!({:accounting_period => output[:accounting_period]}) #if output[:accounting_period]
    end
    where_hash
  end
  
  def results(where_hash = {})
    result = output_model.where(where_hash).select("result as #{name}").first
    result[name] if result
  end

end
