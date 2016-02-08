class Optimization::Optimizator
  attr_reader :options
  attr_reader :tarif_list_generator, :query_constructor, :calls_stat_calculator, :call_stat_param_calculator, :tarif_cost_calculator
  attr_reader :tarif_results
  
  def initialize(options = {})
    @options = options
    @tarif_results = {}
  end

  def calculate_tarifs_cost
    init_tarif_list_generator

    options[:services_by_operator][:operators].each do |operator_id|
      init_query_constructor(operator_id)
      init_calls_stat_calculator
      calls_stat_calculator.update_customer_calls_with_global_categories(query_constructor)
      init_call_stat_param_calculator(operator_id, tarif_list_generator.calculate_all_services)
      call_stat_param_calculator.calculate_stat_params
      calculate_tarifs_cost_by_operator(operator_id)
    end
  end  

  def init_tarif_list_generator
    @tarif_list_generator ||= TarifOptimization::TarifListGenerator.new(options.slice(:services_by_operator, :tarif_list_generator_params))
  end

  def init_query_constructor(operator_id = 1030)
    return @query_constructor if @query_constructor and @query_constructor.instance_values["fq_tarif_operator_id"] == operator_id
    @query_constructor = TarifOptimization::QueryConstructor.new(nil, {:tarif_class_ids => tarif_list_generator.all_services_by_operator[operator_id] }, 
      operator_id, options[:user_input][:user_region_id], true)
  end
  
  def calls_stat_calculator(operator_id = 1030)
    @calls_stat_calculator ||= Customer::Call::StatCalculator.new(options[:user_input].slice(:accounting_period, :call_run_id) )
  end
  
  def init_calls_stat_calculator
    calls_stat_calculator.calculate_calculation_scope(query_constructor, options[:user_input][:selected_service_categories])
  end
   
  def init_call_stat_param_calculator(operator_id, service_ids)
    options_for_stat_params_calculator = options[:user_input].slice(:user_region_id, :accounting_period, :call_run_id).
      merge({:operator_id => operator_id, :service_ids => service_ids})
    @call_stat_param_calculator = Optimization::CallStatParamsCalculator.new(self, options_for_stat_params_calculator)
  end
  
  def calculate_tarifs_cost_by_operator(operator_id)
    options[:services_by_operator][:tarifs][operator_id].each do |tarif_id|    
      tarif_list_generator.calculate_tarif_sets_and_slices(operator_id, tarif_id)
      init_tarif_cost_calculator  
      tarif_cost_calculator.calculate_tarifs_cost_by_tarif(tarif_id)
    end
  end
  
  def init_tarif_cost_calculator
    @tarif_cost_calculator = Optimization::TarifsCostCalculator.new(self, {})
  end
  
  
end
