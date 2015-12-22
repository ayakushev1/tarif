module Comparison::OptimizationsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::ArrayOfHashable,
          SavableInSession::SessionInitializers

  def comparison_optimizations_table
    model_to_show = user_type == :admin ? Comparison::Optimization : Comparison::Optimization.published
    options = {:base_name => 'comparison_optimizations', :current_id_name => 'comparison_optimization_id', :id_name => 'id', :pagination_per_page => 10}
    create_tableable(model_to_show, options)
  end
  
  def comparison_groups    
    model_to_show = comparison_optimization_form.model ? comparison_optimization_form.model.groups : nil
    options = {:base_name => 'comparison_groups', :current_id_name => 'comparison_group_id', :id_name => 'id', :pagination_per_page => 10}
    create_tableable(model_to_show, options)
  end
  
  def check_current_id_exists
    session[:current_id]['comparison_optimization_id'] = params[:id] if session[:current_id]['comparison_optimization_id'].blank?
  end
  
  def set_run_id
#    raise(StandardError) if !session[:current_id]['comparison_group_id']
    comparison_group = Comparison::Group.where(:id => session[:current_id]['comparison_group_id']).first
    if comparison_group and comparison_group.result
        session[:filtr]["service_set_choicer_filtr"] ||={}
        session[:filtr]["service_set_choicer_filtr"]['result_service_set_id'] = comparison_group.result['service_set_ids']
    end
  end
  
  def set_back_path
    session[:back_path]['service_sets_result_return_link_to'] = 'comparison_optimization_path'
  end

  def comparison_progress_bar
    return @comparison_progress_bar if @comparison_progress_bar
    options = {'action_on_update_progress' => comparison_calculation_status_path(params[:id])}.merge(
      background_process_informer.current_values)
    @comparison_progress_bar ||= create_progress_barable('comparison_progress_bar', options)
  end

  def background_process_informer
    @background_process_informer ||= Customer::BackgroundStat::Informer.new('calculating_comparison', current_or_guest_user.id)
  end
  

end
