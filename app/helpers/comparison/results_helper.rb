module Comparison::ResultsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_results_table
    create_tableable(Comparison::Result)
  end
  
  def optimization_result
#    raise(StandardError, comparison_result.optimization_result)
    options = {:base_name => 'optimization_result', :current_id_name => 'call_type', :id_name => 'call_type', :pagination_per_page => 100}
    create_array_of_hashable(comparison_result.optimization_result, options)
  end
  

end
