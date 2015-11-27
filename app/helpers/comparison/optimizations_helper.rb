module Comparison::OptimizationsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_optimizations_table
    create_tableable(Comparison::Optimization)
  end
  
  def comparison_groups    
    create_tableable(comparison_optimization_form.model ? comparison_optimization_form.model.groups : nil)
  end
  
end
