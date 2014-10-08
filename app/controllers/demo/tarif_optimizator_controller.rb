class Demo::TarifOptimizatorController < Customer::TarifOptimizatorController

  def check_if_optimization_options_are_in_session  
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if !session[:filtr] or session[:filtr]['service_choices_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = if saved_tarif_optimization_inputs.blank? or saved_tarif_optimization_inputs['service_choices'].blank?
        {
          'tarifs_bln' => ServiceHelper::Services.tarifs[1025], 
          'tarifs_mgf' => ServiceHelper::Services.tarifs[1028], 
          'tarifs_mts' => ServiceHelper::Services.tarifs[1030],
          'tarif_options_bln' => ServiceHelper::Services.tarif_options_by_type[1025][:calls],
          'tarif_options_mgf' => ServiceHelper::Services.tarif_options_by_type[1028][:calls], 
          'tarif_options_mts' => ServiceHelper::Services.tarif_options_by_type[1030][:calls], 
          'common_services_bln' => ServiceHelper::Services.common_services[1025], 
          'common_services_mgf' => ServiceHelper::Services.common_services[1028], 
          'common_services_mts' => ServiceHelper::Services.common_services[1030], 
          'accounting_period' => accounting_period,
          'calculate_only_chosen_services' => 'false',
          'calculate_with_limited_scope' => 'false'
          }        
      else
        (saved_tarif_optimization_inputs['service_choices'] || {}).merge({'accounting_period' => accounting_period, 'calculate_only_chosen_services' => 'false'})
      end 
    end

    if !session[:filtr] or session[:filtr]['services_select_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = if true #saved_tarif_optimization_inputs.blank? or saved_tarif_optimization_inputs['services_select'].blank?
        {
          'operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
          'tarifs' => 'true', 'common_services' => 'true', 
          'all_tarif_options' => 'false'
          }        
      else
        saved_tarif_optimization_inputs['services_select'] || {}
      end 
    end
    
    if !session[:filtr] or session[:filtr]['service_categories_select_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['service_categories_select_filtr'] ||= {}
      session[:filtr]['service_categories_select_filtr']  = if saved_tarif_optimization_inputs.blank? or saved_tarif_optimization_inputs['service_categories_select'].blank?
        ServiceHelper::SelectedCategoriesBuilder.selected_services_to_session_format
      else
        saved_tarif_optimization_inputs['service_categories_select'] || {}
      end 
    end
#    raise(StandardError)
    
    if !session[:filtr] or session[:filtr]['optimization_params_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = if true #saved_tarif_optimization_inputs.blank? or saved_tarif_optimization_inputs['optimization_params'].blank?
        {
          'calculate_on_background' => 'true',
          'service_set_based_on_tarif_sets_or_tarif_results' => 'final_tarif_sets_by_parts',
          'operator_id' => 1030,
          'calculate_with_multiple_use' => 'true',
          'simplify_tarif_results' => 'true',
          'save_tarif_results_ord' => 'false',
          'analyze_memory_used' => 'false',
          'analyze_query_constructor_performance' => 'false',
          'save_interim_results_after_calculating_tarif_results' => 'false',
  #        'save_interim_results_after_calculating_final_tarif_sets' => 'false',
          'service_ids_batch_size' => 10,
          'use_short_tarif_set_name' => 'true',
          'show_zero_tarif_result_by_parts' => 'false',
          'if_update_tarif_sets_to_calculate_from_with_cons_tarif_results' => 'true',
          'max_tarif_set_count_per_tarif' => 1,
          'eliminate_identical_tarif_sets' => 'true',
          'use_price_comparison_in_current_tarif_set_calculation' => 'true',
          'save_current_tarif_set_calculation_history' => 'false',
          'part_sort_criteria_in_price_optimization' => 'auto',   
          'what_format_of_results' => 'results_for_customer',     
        } 
      else
        saved_tarif_optimization_inputs['optimization_params'] || {}
      end
    end
  end
   
end
