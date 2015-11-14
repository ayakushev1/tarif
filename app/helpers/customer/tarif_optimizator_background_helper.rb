module Customer::TarifOptimizatorBackgroundHelper
  include SavableInSession::ProgressBarable

  attr_reader :background_process_informer_operators, :background_process_informer_tarifs, :background_process_informer_tarif
  
  def operators_optimization_progress_bar
    options = {'action_on_update_progress' => customer_tarif_optimizators_calculation_status_path}.merge(
      background_process_informer_operators.current_values);
    create_progress_barable('operators_optimization', options)
  end
  
  def tarifs_optimization_progress_bar
    options = {'action_on_update_progress' => customer_tarif_optimizators_calculation_status_path}.merge(
      background_process_informer_tarifs.current_values);
    create_progress_barable('tarifs_optimization', options)
#    raise(StandardError)
  end
  
  def tarif_optimization_progress_bar
    options = {'action_on_update_progress' => customer_tarif_optimizators_calculation_status_path}.merge(
      background_process_informer_tarif.current_values);
    create_progress_barable('tarif_optimization', options)
  end

  def prepare_background_process_informer
    [background_process_informer_operators, background_process_informer_tarifs, background_process_informer_tarif].compact.each do |background_process_informer|
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init
    end
    
  end
  
  def init_background_process_informer
    @background_process_informer_operators ||= Customer::BackgroundStat::Informer.new('operators_optimization', current_or_guest_user_id)
    @background_process_informer_tarifs ||= Customer::BackgroundStat::Informer.new('tarifs_optimization', current_or_guest_user_id)
    @background_process_informer_tarif ||= Customer::BackgroundStat::Informer.new('tarif_optimization', current_or_guest_user_id)
  end
  
end
