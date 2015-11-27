module Comparison::OptimizationsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_optimizations_table
    create_tableable(Comparison::Optimization)
  end
  
  def comparison_groups    
    create_tableable(comparison_optimization_form.model ? comparison_optimization_form.model.groups : nil)
  end
  
  def set_run_id
#    raise(StandardError) if !session[:current_id]['comparison_group_id']
    comparison_group = Comparison::Group.where(:id => session[:current_id]['comparison_group_id']).first
    if comparison_group
        session[:filtr]["service_set_choicer_filtr"] ||={}
        session[:filtr]["service_set_choicer_filtr"]['result_service_set_id'] = comparison_group.result['service_set_ids']
    end

  end

end
