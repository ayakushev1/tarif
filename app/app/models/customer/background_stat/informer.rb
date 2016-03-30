class Customer::BackgroundStat::Informer < Aspector::Base #ServiceHelper::BackgroundProcessInformer
  include Customer::BackgroundStat::Helper
  
  attr_reader :name, :process_info_model, :user_id
  
  def initialize(name = 'default_background_process_name', user_id = -1)
    @name = name
    @user_id = user_id
    @process_info_model = Customer::BackgroundStat.where(:result_type => 'background_processes', :result_name => name, :user_id => user_id)
  end

  around :calculate_all_operator_tarifs do |proxy, *arg, &block|
    background_process_informer_operators.init(0.0, tarif_list_generator.operators.size)
    background_process_informer_operators.increase_current_value(0, "calculating all_operator_tarifs")

    result = proxy.call(*arg, &block)
    
    background_process_informer_operators.increase_current_value(0, "finish calculating operators")
    background_process_informer_operators.finish
    result
  end

  around :calculate_one_operator do |proxy, *arg, &block|
    operator = arg[0]
    background_process_informer_tarifs.init(0.0, tarif_list_generator.tarifs[operator].size )          

    result = proxy.call(*arg, &block)
    
    background_process_informer_operators.increase_current_value(1)

    background_process_informer_tarifs.increase_current_value(0, "finish calculating one operator tarifs")
    background_process_informer_tarifs.finish
    result
  end

  after :init_input_for_one_tarif_calculation do |proxy, *arg, &block|
    operator = arg[0]
    background_process_informer_tarif.init(0.0, tarif_list_generator.all_tarif_parts_count[operator])    
  end
  
  after :calculate_one_tarif do |proxy, *arg, &block|
    background_process_informer_tarifs.increase_current_value(1)

    background_process_informer_tarif.increase_current_value(0, "finish calculating one tarif")
    background_process_informer_tarif.finish
  end

  after :calculate_tarif_results_batch do |proxy, *arg, &block|
    batch_low_limit = arg[0]
    batch_high_limit = arg[1]
    background_process_informer_tarif.increase_current_value(batch_high_limit - batch_low_limit + 1)
  end

  before :calculate_and_save_final_tarif_sets_by_tarif do |proxy, *arg, &block|
    background_process_informer_tarif.init(0.0, 10.0)
    background_process_informer_tarif.increase_current_value(0, "init final_tarif_set_generator")
  end

  around :calculate_final_tarif_sets_by_tarif do |proxy, *arg, &block|
    result = proxy.call(*arg, &block)
    background_process_informer_tarif.increase_current_value(1, 'calculate_final_tarif_sets_by_tarif')
    result
  end

  around :prepare_and_save_final_tarif_results_by_tarif_for_presenatation do |proxy, *arg, &block|
    background_process_informer_tarif.increase_current_value(0, "get saved final_tarif_sets")

    result = proxy.call(*arg, &block)

    background_process_informer_tarif.increase_current_value(0, "")
    background_process_informer_tarif.finish
    
    result
  end
end
