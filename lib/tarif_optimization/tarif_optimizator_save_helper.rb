module TarifOptimization::TarifOptimizatorSaveHelper
  def save_tarif_results(operator, tarif = nil, accounting_period = '1_2014', result_to_save = {})
    output = {}
    optimization_result_saver.override({:operator_id => operator.to_i, :tarif_id => tarif.to_i, :accounting_period => accounting_period, :result => {
      :tarif_sets => result_to_save[:tarif_sets],
      :cons_tarif_results => current_tarif_optimization_results.cons_tarif_results,
      :cons_tarif_results_by_parts => current_tarif_optimization_results.cons_tarif_results_by_parts,
      :tarif_results => result_to_save[:tarif_results], 
      :groupped_identical_services => result_to_save[:groupped_identical_services],
      :tarif_results_ord => (save_tarif_results_ord ? current_tarif_optimization_results.tarif_results_ord : {}), 

      :services_that_depended_on => tarif_list_generator.services_that_depended_on,      
      :service_description => tarif_list_generator.service_description,   
      :common_services_by_parts => tarif_list_generator.common_services_by_parts,   
      :common_services => tarif_list_generator.common_services,
      } } )
  end

  def prepare_and_save_final_tarif_results_by_tarif_for_presenatation(operator, tarif, accounting_period, input_data = {}, saved_results = nil)
    saved_results ||= final_tarif_sets_saver.results({:operator_id => operator, :tarif_id => tarif, :accounting_period => accounting_period})
    
    prepared_final_tarif_results = TarifOptimization::FinalTarifResultPreparator.prepare_final_tarif_results_by_tarif({
      :final_tarif_sets => saved_results['final_tarif_sets'].stringify_keys,
      :tarif_results => saved_results['tarif_results'].stringify_keys,
      :groupped_identical_services => (saved_results['groupped_identical_services'] || {}).stringify_keys,
      :service_description => saved_results['service_description'].stringify_keys,
      :operator_description => saved_results['operator_description'].stringify_keys,
      :categories => saved_results['categories'].stringify_keys,
      :tarif_categories => saved_results['tarif_categories'].stringify_keys,
      :tarif_category_groups => saved_results['tarif_category_groups'].stringify_keys,
      :tarif_class_categories_by_category_group => saved_results['tarif_class_categories_by_category_group'].stringify_keys,
      :operator => operator, 
      :tarif => tarif, 
    })

    prepared_final_tarif_results_saver.override({:operator_id => operator.to_i, :tarif_id => tarif.to_i, :accounting_period => accounting_period, :result => prepared_final_tarif_results})
    result = {}  
  end

  def update_minor_results
#    tarif_list_generator.calculate_service_packs; tarif_list_generator.calculate_service_packs_by_parts
    
    start_time = minor_result_saver.results['start_time'].to_datetime if minor_result_saver.results and minor_result_saver.results['start_time']
    start_time = performance_checker.start if performance_checker and !start_time
    
    saved_performance_results = minor_result_saver.results['original_performance_results'] if minor_result_saver.results
    updated_original_performance_results = performance_checker.add_current_results_to_saved_results(saved_performance_results, start_time) if performance_checker
    
    minor_result_saver.save({:result => 
      {:performance_results => (performance_checker ? performance_checker.show_stat_hash(updated_original_performance_results) : {}),
       :original_performance_results => updated_original_performance_results,
       :start_time => start_time,
#       :calls_stat => calls_stat_calculator.calculate_calls_stat(query_constructor),
#         :service_packs_by_parts => tarif_list_generator.tarif_sets, #,будет показывать только последний посчитанный тариф
       :service_packs_by_parts => tarif_list_generator.service_packs_by_parts,
       }})
  end
  
end

