class Customer::BackgroundStat::Informer #ServiceHelper::BackgroundProcessInformer
  include Customer::BackgroundStat::Helper
  
  attr_reader :name, :process_info_model, :user_id
  
  def initialize(name, user_id)
    @name = name || 'default_background_process_name'
    @user_id = user_id
    @process_info_model = Customer::BackgroundStat.where(:result_type => 'background_processes', :result_name => name, :user_id => user_id)
  end

end
