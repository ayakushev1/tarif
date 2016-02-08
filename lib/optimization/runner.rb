class Optimization::Runner
  attr_reader :options
  
  def initialize(options = {})
    @options = default_params(options)    
  end
  
  def optimizator
    Optimization::Optimizator.new(options)
  end
  
  def default_params(options = {})
    optimization_params = options[:optimization_params] || {}
    calculation_choices = options[:calculation_choices] || {}
    selected_service_categories = options[:selected_service_categories] || defauls_selected_service_categories
    services_by_operator = options[:services_by_operator] || default_services
    temp_value = options[:temp_value] || {}
    {
     :tarif_optimizator_input => {
        :save_tarif_results_ord => optimization_params['save_tarif_results_ord'], 
        :save_new_final_tarif_results_in_my_batches => optimization_params['save_new_final_tarif_results_in_my_batches'],
        :calculate_old_final_tarif_preparator => optimization_params['calculate_old_final_tarif_preparator'],
        :save_interim_results_after_calculating_tarif_results => optimization_params['save_interim_results_after_calculating_tarif_results'], 
        :analyze_query_constructor_performance => optimization_params['analyze_query_constructor_performance'], 
        :max_number_of_tarif_optimization_workers => optimization_params['max_number_of_tarif_optimization_workers'],
       },
     :optimization_params => {
        :service_ids_batch_size => optimization_params['service_ids_batch_size'], 
        :simplify_tarif_results => optimization_params['simplify_tarif_results'], 
       },
     :user_input => {
        :accounting_period => calculation_choices['accounting_period'] || '1_2015',
        :call_run_id => calculation_choices['call_run_id'] || 553,
        :calculate_with_limited_scope => calculation_choices['calculate_with_limited_scope'],
        :selected_service_categories => selected_service_categories,
        :result_run_id => calculation_choices['result_run_id'],
        :user_id => temp_value[:user_id] || 0,
        :user_region_id => temp_value[:user_region_id] || 1238,             
       },
     :services_by_operator => services_by_operator,
     :final_tarif_set_generator_params => {
        :use_short_tarif_set_name => optimization_params['use_short_tarif_set_name'], 
        :max_tarif_set_count_per_tarif => optimization_params['max_tarif_set_count_per_tarif'],
        :save_current_tarif_set_calculation_history => optimization_params['save_current_tarif_set_calculation_history'],
        :use_price_comparison_in_current_tarif_set_calculation => optimization_params['use_price_comparison_in_current_tarif_set_calculation'],
        :part_sort_criteria_in_price_optimization => optimization_params['part_sort_criteria_in_price_optimization'],       
       },
     :tarif_list_generator_params => {
        :calculate_with_multiple_use => optimization_params['calculate_with_multiple_use'],
        :calculate_only_chosen_services => calculation_choices['calculate_only_chosen_services'],
        :calculate_with_fixed_services => calculation_choices['calculate_with_fixed_services'],       
       }, 
     :tarif_result_simlifier_params => {
        :if_update_tarif_sets_to_calculate_from_with_cons_tarif_results => optimization_params['if_update_tarif_sets_to_calculate_from_with_cons_tarif_results'],
        :eliminate_identical_tarif_sets => optimization_params['eliminate_identical_tarif_sets'],       
       }, 
     }   
  end

  def defauls_selected_service_categories
    selected_services = Customer::Info::ServiceCategoriesSelect.default_selected_categories(:admin)
    Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(selected_services)
  end

  def default_services
    {
      :operators => [1030],
      :tarifs => {1023 => [], 1025 => [], 1028 => [], 1030 => [200]},
      :common_services => {1023 => [], 1025 => [], 1028 => [], 1030 => []},
      :tarif_options => {1023 => [], 1025 => [], 1028 => [], 1030 => [295]}
    }
  end    
end
