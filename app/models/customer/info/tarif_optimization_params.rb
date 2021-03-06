# == Schema Information
#
# Table name: customer_infos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime
#

class Customer::Info::TarifOptimizationParams < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 7)
  end

  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.default_values
    {
      'calculate_on_background' => 'true',
      'service_set_based_on_tarif_sets_or_tarif_results' => 'final_tarif_sets_by_parts',
#      'operator_id' => 1030,
      'calculate_with_multiple_use' => 'true',
      'simplify_tarif_results' => 'true',
      'save_tarif_results_ord' => 'false',
      'analyze_query_constructor_performance' => 'false',
      'save_interim_results_after_calculating_tarif_results' => 'false',
  #        'save_interim_results_after_calculating_final_tarif_sets' => 'false',
      'service_ids_batch_size' => 5,
      'use_short_tarif_set_name' => 'true',
      'show_zero_tarif_result_by_parts' => 'false',
      'if_update_tarif_sets_to_calculate_from_with_cons_tarif_results' => 'true',
      'max_tarif_set_count_per_tarif' => 1,
      'eliminate_identical_tarif_sets' => 'true',
      'use_price_comparison_in_current_tarif_set_calculation' => 'true',
      'save_current_tarif_set_calculation_history' => 'false',
      'part_sort_criteria_in_price_optimization' => 'auto',   
      'what_format_of_results' => 'results_for_customer',     
      'calculate_background_with_spawnling' => 'false',
      'max_number_of_tarif_optimization_workers' => 3,
      'calculate_old_final_tarif_preparator' => 'false',
      'save_new_final_tarif_results_in_my_batches' => 'true'
    }
  end


end
