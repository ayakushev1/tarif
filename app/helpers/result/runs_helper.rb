module Result::RunsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
  SavableInSession::ProgressBarable, SavableInSession::SessionInitializers
  
  def current_user_id
    current_user.id
  end
  
  def run_id
    Result::Run.where(:user_id => current_user.id, :run => 1).first[:id]
  end
  
  def service_set_id
    session[:current_id]['service_set_id']
  end
  
  def service_id
    session[:current_id]['service_id']
  end
  
  def all_service_ids
    Result::ServiceSet.where(:run_id => run_id).pluck(:service_ids).flatten.uniq
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
    TarifClass.where(:id => service_ids).select(:id, :name, :features).each do |row|
      s_desc[row[:id]] = {'service_name' => row[:name], 'service_http' => row[:features]['http']}
    end
    s_desc
  end
    
  def result_service_sets
    options = {:base_name => 'service_sets', :current_id_name => 'service_set_id', :id_name => 'service_set_id', :pagination_per_page => 5}
    create_tableable(Result::ServiceSet.includes(:operator, :tarif).where(:run_id => run_id).order(:price), options)
  end
  
  def if_show_aggregate_results
    create_filtrable("if_show_aggregate_results")
  end

  def result_services
    options = {:base_name => 'services', :current_id_name => 'service_id', :id_name => 'service_id', :pagination_per_page => 20}
    create_tableable(Result::Service.where(:run_id => run_id, :service_set_id => service_set_id).
      where(zero_string_condition).order(price: :desc), options)
  end
  
  def result_service_categories
    options = {:base_name => 'service_categories', :current_id_name => 'service_category_name', :id_name => 'service_category_name', :pagination_per_page => 100}
    create_tableable(Result::ServiceCategory.where(:run_id => run_id, :service_set_id => service_set_id, :service_id => service_id).
      where(zero_string_condition).order(:rouming_ids, :geo_ids, :partner_ids, :calls_ids, :fix_ids), options)
  end
  
  def result_agregates
    options = {:base_name => 'agregates', :current_id_name => 'aggregated_service_category_name', :id_name => 'aggregated_service_category_name', :pagination_per_page => 100}
    create_tableable(Result::Agregate.where(:run_id => run_id, :service_set_id => service_set_id).
      where(zero_string_condition).order(:rouming_ids, :geo_ids, :partner_ids, :calls_ids, :fix_ids), options)
  end


  def calls_stat_options
    create_filtrable("calls_stat_options")
  end

  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    calls_stat_options = {"rouming" => 'true'} if calls_stat_options.blank?
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category', :pagination_per_page => 100}
    create_array_of_hashable(minor_result_presenter.calls_stat_array(calls_stat_options), options )
  end
   
  def optimization_params_session_info
    (session[:filtr] and session[:filtr]['optimization_params_filtr']) ? session[:filtr]['optimization_params_filtr'] : {}
  end

end
