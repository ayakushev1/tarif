class Comparison::Optimization
  
  def self.calculate_from_optimization_list(optimization_list_keys = [], test = false)
    Comparison::Call.generate_calls_for_new_inits
    result = {}
    optimization_list_keys.collect do |optimization_list_key|
      result[optimization_list_key] = calculate_one_item_from_optimization_list(optimization_list_key, test)      
    end
  end
  
  def self.calculate_one_item_from_optimization_list(optimization_list_key, test = false)
    call_type_keys = optimization_list[optimization_list_key][:result_runs].keys
    optimization_type_key = optimization_list[optimization_list_key][:optimization_type]
    optimization_type = optimization_type_list[optimization_type_key]
    result = []
    call_type_keys.each do |call_type_key|
      call_type = Comparison::Call.init_list[call_type_key]
      
      optimization_list[optimization_list_key][:result_runs][call_type_key].each do |operator_id, result_run_id|
        call_run_id = call_type["call_run_by_operator"][operator_id]
        
        local_options = {
          :call_run_id => call_run_id,
          :accounting_period => accounting_period_by_call_run_id(call_run_id),
          :result_run_id => result_run_id,
          :operators => [operator_id],
          :for_service_categories => optimization_type[:for_service_categories],
          :for_services_by_operator => optimization_type[:for_services_by_operator],
        }
        optimization_type_options = optimization_type.deep_merge(local_options)
        options = Comparison::Optimization::Init.base_params(optimization_type_options)
        
#        raise(StandardError, options.keys)
        result << calculate_one_optimization(optimization_list_key, options, test)
      end
    end
    update_comparison_result_on_calculation(optimization_list_key)
    result
  end

  def self.calculate_one_optimization(optimization_list_key, options, test = false)    
    result = options[:calculation_choices].slice("result_run_id", "call_run_id")
    result.merge!(options[:services_by_operator].slice(:operators))
    return result if test

    true ? 
      TarifOptimization::TarifOptimizatorRunner.recalculate_with_delayed_job(options) :
      TarifOptimization::TarifOptimizatorRunner.recalculate_direct(options)
    
    update_result_run_on_calculation(optimization_list_key, options)    
    result
  end
  
  def self.update_result_run_on_calculation(optimization_list_key, options)
    Result::Run.where(:id => options[:calculation_choices]["result_run_id"]).first_or_create.update({
      :name => optimization_list[optimization_list_key][:name],
      :description => optimization_list[optimization_list_key][:description],
      :user_id => nil,
      :run => 1,
      
      :call_run_id => options[:calculation_choices]["call_run_id"],
      :accounting_period => options[:calculation_choices]["accounting_period"],
      :optimization_type_id => 6,
      :optimization_params => options[:optimization_params],
      :calculation_choices => options[:calculation_choices],
      :selected_service_categories => options[:selected_service_categories],
      :services_by_operator => options[:services_by_operator],
      :temp_value => options[:temp_value],
      :service_choices => {},
      :services_select => {},
      :services_for_calculation_select => {},
      :service_categories_select => {},
    })
  end

  def self.update_comparison_result_on_calculation(optimization_list_key)
    Comparison::Result.where(:optimization_list_key => optimization_list_key.to_s).first_or_create do |result|
      result.name = optimization_list[optimization_list_key][:name]
      result.description = optimization_list[optimization_list_key][:description]
      result.publication_status_id = 100
      result.publication_order = 10000
      result.optimization_list_key = optimization_list_key.to_s
#      result.optimization_list_item = optimization_list[optimization_list_key]
      result.optimization_result = [{}]
    end.update({:optimization_list_item => optimization_list[optimization_list_key]})
  end
  
  def self.unloaded_optimization_list_keys
    []
  end  
  
  def self.optimization_list_result_run_ids
    optimization_list.values.map{|o| o[:result_runs].values.map(&:values) }.flatten
  end
  
  def self.loaded_result_run_ids
    Result::Run.where("user_id is null").pluck(:id).uniq
  end
  
  def self.accounting_period_by_call_run_id(call_run_id)
    '1_2015'
  end
  
  def self.optimization_list
    {
      :base_rank => {
        :name => "base_rank",
        :description => "all_operators, tarifs_only, own_and_home_regions for students",
        :optimization_type => :all_operators_tarifs_only_own_and_home_regions, 
        :result_runs => {
          :student => {1023 => 0, 1025 => 0, 1028 => 0, 1030 => 0}
        },
      },
    }
  end

  def self.optimization_type_list
    {
      :all_operators_tarifs_only_own_and_home_regions => {
        :for_service_categories => {
            :country_roming => true,
            :intern_roming => true,
            :mms => true,
            :internet => true,          
        },
        :for_services_by_operator => [],
      },
    }
  end

end

