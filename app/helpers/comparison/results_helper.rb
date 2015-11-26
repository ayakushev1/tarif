module Comparison::ResultsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_results_table
    create_tableable(Comparison::Result)
  end
  
  def optimization_result
#    raise(StandardError, comparison_result.inspect)
    options = {:base_name => 'optimization_result', :current_id_name => 'call_type', :id_name => 'call_type', :pagination_per_page => 100}
    create_array_of_hashable(comparison_result.optimization_result, options)
  end
  
  def set_run_id
    call_type = session[:current_id]['call_type']
    

    comparison_result.optimization_result.each do |optimization_result|        
      if optimization_result['call_type'] == call_type
        session[:filtr]["service_set_choicer_filtr"] ||={}
#        session[:filtr]["service_set_choicer_filtr"]['result_service_set_id'] = {}

        session[:filtr]['results_select_filtr'] ||= {}
        session[:filtr]['results_select_filtr']['result_run_id'] = optimization_result["result_run_ids"][0] if optimization_result["result_run_ids"]
        
        return true
      end
    end if comparison_result and comparison_result.optimization_result
  end
  

end
