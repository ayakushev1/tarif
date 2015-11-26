module Result::ServiceSetsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers
  
  def results_select
    create_filtrable("results_select")
  end

  def run_id
    session[:filtr]['results_select_filtr'] ||= {}
    session[:filtr]['results_select_filtr']['result_run_id'] = params[:result_run_id] if params[:result_run_id]
    params[:result_run_id] || (session_filtr_params(results_select)['result_run_id'] || -1).to_i
#    run = Result::Run.where(:user_id => current_or_guest_user_id, :run => 1).first
#    run ? run[:id] : -1
  end
  
  def service_set_id
    session[:current_id]['service_set_id']
  end
  
  def service_id
    session[:current_id]['service_id']
  end
  
  def identical_services
    @identical_services ||= Result::ServiceSet.where(:run_id => run_id).pluck(:identical_services).flatten(2).uniq
  end
  
  def all_service_ids
    @all_service_ids ||= Result::ServiceSet.where(:run_id => run_id).pluck(:service_ids).flatten.uniq
  end

  def zero_string_condition
    if (optimization_params_session_info['show_zero_tarif_result_by_parts'] || 'false') == 'true'
      'true'
    else
      "price > 0.0 or call_id_count > 0"
    end
  end  
   
  def service_description(service_ids = [])
    s_desc = {}
    @service_description ||= TarifClass.where(:id => service_ids).select(:id, :name, :features).each do |row|
      s_desc[row[:id]] = {'service_name' => row[:name], 'service_http' => row[:features]['http']}
    end
    s_desc
  end
    
  def result_service_sets
    return @result_service_sets if @result_service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_set_id', :id_name => 'service_set_id', :pagination_per_page => 10}
    @result_service_sets = 
    create_tableable(Result::ServiceSet.includes(:operator, :tarif).where(:run_id => run_id).order(:price), options)
  end
  
  def result_service_sets_return_link_to
    result_run = Result::Run.where(:id => run_id).first
    comparison_result_id = session[:current_id]['comparison_result_id']
#    raise(StandardError, comparison_result_id)
    (result_run and result_run.user_id) ? result_runs_path : comparison_result_path(comparison_result_id)
  end
  
  def if_show_aggregate_results
    create_filtrable("if_show_aggregate_results")
  end

  def result_services
    options = {:base_name => 'services', :current_id_name => 'service_id', :id_name => 'service_id', :pagination_per_page => 20}
    @result_services ||= create_tableable(Result::Service.where(:run_id => run_id, :service_set_id => service_set_id).
      where(zero_string_condition).order(price: :desc), options)
  end
  
  def result_service_categories
    options = {:base_name => 'service_categories', :current_id_name => 'service_category_name', :id_name => 'service_category_name', :pagination_per_page => 100}
    @result_service_categories ||= create_tableable(Result::ServiceCategory.where(:run_id => run_id, :service_set_id => service_set_id, :service_id => service_id).
      where(zero_string_condition).order(:rouming_ids, :geo_ids, :partner_ids, :calls_ids, :fix_ids), options)
  end
  
  def result_agregates
    options = {:base_name => 'agregates', :current_id_name => 'aggregated_service_category_name', :id_name => 'aggregated_service_category_name', :pagination_per_page => 100}
    @result_agregates ||= create_tableable(Result::Agregate.where(:run_id => run_id, :service_set_id => service_set_id).
      where(zero_string_condition).order(:rouming_ids, :geo_ids, :partner_ids, :calls_ids, :fix_ids), options)
  end


  def calls_stat_options
    create_filtrable("calls_stat_options")
  end

  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'} + ['fixed_payments']
    calls_stat_options = {"rouming" => 'true'} if calls_stat_options.blank?
    
    operator_id = Result::ServiceSet.where(:run_id => run_id, :service_set_id => service_set_id).pluck(:operator_id)[0]
    
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category', :pagination_per_page => 100}
    @calls_stat ||= create_array_of_hashable(
      Result::CallStat.where(:run_id => run_id, :operator_id => operator_id).first_or_create.calls_stat_array(calls_stat_options), options )
  end
   
  def comparison_options
    create_filtrable("comparison_options")
  end

  def service_set_choicer
    create_filtrable("service_set_choicer")
  end

  def comparison_service_sets
    filtr = session_filtr_params(comparison_options)
    comparison_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    comparison_options = {"service" => 'true'} if comparison_options.blank?
    
    session[:filtr]["service_set_choicer_filtr"] ||= {}
    if ((session[:filtr]["service_set_choicer_filtr"]['result_service_set_id'] || {}).values.compact - [""]).blank?
      session[:filtr]["service_set_choicer_filtr"]['result_service_set_id']= take_service_set_ids_from_comparison_results
    end     
    
    session_filtr_params_service_set_choicer = session_filtr_params(service_set_choicer)
    service_set_ids = ((session_filtr_params_service_set_choicer['result_service_set_id'] || {}).values.compact - [""])
#    raise(StandardError, [session[:filtr]["service_set_choicer_filtr"], session_filtr_params_service_set_choicer, service_set_ids].join("\n"))
    
    comparison_base = session_filtr_params_service_set_choicer['comparison_base']
    
    options = {:base_name => 'comparison_service_sets', :current_id_name => 'global_category_id', :id_name => 'global_category_id', :pagination_per_page => 100}
    @comparison_service_sets ||= create_array_of_hashable(
      Result::Agregate.compare_service_sets_of_one_run({run_id => service_set_ids}, [:price], comparison_options, comparison_base), options )
  end
  
  def take_service_set_ids_from_comparison_results
    comparison_result_id = session[:current_id]['comparison_result_id']
    call_type = session[:current_id]['call_type']
    comparison_result = Comparison::Result.where(:id => comparison_result_id).first

    comparison_result.optimization_result.each do |optimization_result|        
      return optimization_result['service_set_ids'] if optimization_result['call_type'] == call_type
    end if comparison_result and comparison_result.optimization_result
#    raise(StandardError, current_comparison_result)
  end
   
  def optimization_params_session_info
    (session[:filtr] and session[:filtr]['optimization_params_filtr']) ? session[:filtr]['optimization_params_filtr'] : {}
  end

end
