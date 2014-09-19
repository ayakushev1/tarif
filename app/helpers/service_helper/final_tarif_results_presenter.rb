class ServiceHelper::FinalTarifResultsPresenter
  attr_reader :user_id, :level_to_show_tarif_result_by_parts
  
  def initialize(options = {})
    @user_id = options[:user_id] || 0
    @level_to_show_tarif_result_by_parts = options[:show_zero_tarif_result_by_parts] == 'true' ? -1.0 : 0.0
  end
  
  def results
    Customer::Stat.get_results({
      :result_type => 'optimization_results',
      :result_name => 'default_output_results_name',
      :user_id => user_id,
    })
  end
  
  def customer_service_sets_array
    result = []
    prepared_final_tarif_sets['service_set'].each do |service_set_id, prepared_final_tarif_set|
      result << prepared_final_tarif_set.merge({'service_sets_id' => service_set_id})
    end
    result.sort_by!{|item| item['service_set_price']}    
  end
  
  def customer_tarif_results_array(service_set_id)
    result = []
    prepared_final_tarif_sets_1 = prepared_final_tarif_sets
    prepared_final_tarif_sets_1['tarif_results'][service_set_id].each do |service_id, prepared_tarif_result|       
      if prepared_tarif_result['call_id_count'].to_i > level_to_show_tarif_result_by_parts or prepared_tarif_result['price_value'].to_f > level_to_show_tarif_result_by_parts
        result << {'service_id' => service_id}.merge(prepared_tarif_result)
      end
    end if prepared_final_tarif_sets_1 and prepared_final_tarif_sets_1['tarif_results'] and prepared_final_tarif_sets_1['tarif_results'][service_set_id]
    result
#    result.sort_by!{|item| item['service_set_price']}    
  end
    
  def customer_tarif_detail_results_array(service_set_id, service_id)
    result = []
    prepared_final_tarif_sets_1 = prepared_final_tarif_sets
    prepared_final_tarif_sets_1['tarif_detail_results'][service_set_id][service_id].each do |service_category_name, prepared_tarif_detail_result|       
      if prepared_tarif_detail_result['call_id_count'].to_i > level_to_show_tarif_result_by_parts or prepared_tarif_detail_result['price_value'].to_f > level_to_show_tarif_result_by_parts
        result << {'service_category_name' => service_category_name}.merge(prepared_tarif_detail_result)
      end
    end if prepared_final_tarif_sets_1 and prepared_final_tarif_sets_1['tarif_detail_results'] and  
             prepared_final_tarif_sets_1['tarif_detail_results'][service_set_id] and prepared_final_tarif_sets_1['tarif_detail_results'][service_set_id][service_id]
    result
#    result.sort_by!{|item| item['service_set_price']}    
  end
      
  def prepared_final_tarif_sets
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'prepared_final_tarif_sets',
      :user_id => user_id,
    }, 'prepared_final_tarif_sets')
  end
  
end
