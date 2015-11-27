module Comparison::OptimizationsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_optimizations_table
    create_tableable(Comparison::Optimization)
  end
  
#  def optimization_result
#    raise(StandardError, comparison_result.inspect)
#    options = {:base_name => 'optimization_result', :current_id_name => 'call_type', :id_name => 'call_type', :pagination_per_page => 100}
#    create_array_of_hashable(comparison_result.optimization_result, options)
#  end
  
  def comparison_groups    
    create_tableable(comparison_optimization_form.model ? comparison_optimization_form.model.groups : nil)
  end
  
end
