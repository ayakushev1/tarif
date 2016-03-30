#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'aspector'

class Customer::Stat::PerformanceChecker < Aspector::Base #ServiceHelper::PerformanceChecker  
  include Customer::Stat::PerformanceChecker::Helper
  
  attr_reader :name, :start #, :output_model
  attr_accessor :results
  
  def initialize(name = nil)
    @name = name || 'performance_checker'
#    @output_model = Customer::Stat.where(:result_type => 'performance_checker').where(:result_name => @name)
    @start = current
    @results = {}
  end

  check_points = [
    {:method => :calculate_all_operator_tarifs, :name => 'calculate_all_operator_tarifs', :level => 1},
    {:method => :calculate_one_operator, :name => 'calculate_one_operator', :level => 2},
    {:method => :init_calls_count_by_parts, :name => 'init_calls_count_by_parts', :level => 3},
    {:method => :init_input_for_one_operator_calculation, :name => 'init_input_for_one_operator_calculation', :level => 3},
    {:method => :init_stat_function_collector, :name => 'init_stat_function_collector', :level => 4},
    {:method => :init_query_constructor, :name => 'init_query_constructor', :level => 4},
    {:method => :init_max_formula_order_collector, :name => 'init_max_formula_order_collector', :level => 4},
    {:method => :update_minor_results, :name => 'update_minor_results', :level => 2},
    {:method => :calculate_one_tarif, :name => 'calculate_one_tarif', :level => 3},
    {:method => :init_input_for_one_tarif_calculation, :name => 'init_input_for_one_tarif_calculation', :level => 4},
    {:method => :save_tarif_results, :name => 'save_tarif_results', :level => 4},
    {:method => :simplify_tarif_resuts_by_tarif, :name => 'simplify_tarif_resuts_by_tarif', :level => 4},
    {:method => :calculate_and_save_final_tarif_sets_by_tarif, :name => 'calculate_and_save_final_tarif_sets_by_tarif', :level => 4},
    {:method => :prepare_and_save_final_tarif_results_by_tarif_for_presenatation, :name => 'prepare_and_save_final_tarif_results_by_tarif_for_presenatation', :level => 4},
    {:method => :calculate_tarif_results, :name => 'calculate_tarif_results', :level => 4},
    {:method => :new_preparator_and_saver, :name => 'new_preparator_and_saver', :level => 5},
    {:method => :calculate_tarif_results_batches, :name => 'calculate_tarif_results_batches', :level => 5},
    {:method => :calculate_tarif_results_batch, :name => 'calculate_tarif_results_batch', :level => 6},
    {:method => :calculate_service_part_sql, :name => 'calculate_service_part_sql', :level => 7},
    {:method => :execute_tarif_result_batch_sql, :name => 'execute_tarif_result_batch_sql', :level => 7},
    {:method => :process_tarif_results_batch, :name => 'process_tarif_results_batch', :level => 7},

    {:method => :calculate_final_tarif_sets, :name => 'Final_tarif_set_generator.calculate_final_tarif_sets', :level => 5},
    {:method => :calculate_final_tarif_sets_by_tarif, :name => 'Final_tarif_set_generator.calculate_final_tarif_sets_by_tarif', :level => 6},
    {:method => :update_current_uniq_sets_with_periodic_part, :name => 'Final_tarif_set_generator.update_current_uniq_sets_with_periodic_part', :level => 6},
    {:method => :load_current_uniq_service_sets_to_final_tarif_sets, :name => 'Final_tarif_set_generator.load_current_uniq_service_sets_to_final_tarif_sets', :level => 6},
    {:method => :init_fobidden_info, :name => 'Final_tarif_set_generator.init_fobidden_info', :level => 7},
    {:method => :check_if_final_tarif_set_is_fobidden, :name => 'Final_tarif_set_generator.check_if_final_tarif_set_is_fobidden', :level => 7},

    {:method => :next_tarif_set_by_part, :name => 'Current_tarif_set.next_tarif_set_by_part', :level => 7},

    {:method => :load_comparison_operators, :name => 'Query_constructor.load_comparison_operators', :level => 15},
    {:method => :load_category_ids, :name => 'Query_constructor.load_category_ids', :level => 15},
    {:method => :load_required_service_category_tarif_class_ids, :name => 'Query_constructor.load_required_service_category_tarif_class_ids', :level => 15},
    {:method => :load_service_category_tarif_class_ids_by_tarif_class, :name => 'Query_constructor.load_service_category_tarif_class_ids_by_tarif_class', :level => 15},
    {:method => :load_service_category_group_ids_by_tarif_class, :name => 'Query_constructor.load_service_category_group_ids_by_tarif_class', :level => 15},
    {:method => :load_category_groups, :name => 'Query_constructor.load_category_groups', :level => 15},
    {:method => :load_service_categories, :name => 'Query_constructor.load_service_categories', :level => 15},
    {:method => :load_service_criteria, :name => 'Query_constructor.load_service_criteria', :level => 15},
    {:method => :load_parameters, :name => 'Query_constructor.load_parameters', :level => 15},
    {:method => :calculate_service_criteria_where_hash, :name => 'Query_constructor.calculate_service_criteria_where_hash', :level => 15},
    {:method => :calculate_service_categories_where_hash, :name => 'Query_constructor.calculate_service_categories_where_hash', :level => 15},
    {:method => :calculate_tarif_classes_categories_where_hash, :name => 'Query_constructor.calculate_tarif_classes_categories_where_hash', :level => 15},

    {:method => :set_current_results, :name => 'CurrentTarifOptimizationResults.set_current_results', :level => 8},
    {:method => :update_all_tarif_results_with_missing_prev_results, :name => 'CurrentTarifOptimizationResults.update_all_tarif_results_with_missing_prev_results', :level => 8},

    {:method => :execute_additional_sql_to_check_performance, :name => 'TarifOptimizationSqlBuilder.execute_additional_sql_to_check_performance', :level => 8},
  ]

  check_points.each do  |check_point|
    around check_point[:method] do |proxy, *arg, &block|
      @performance_checker.add_check_point(check_point[:name], check_point[:level]) if @performance_checker
      result = proxy.call(*arg, &block)
      @performance_checker.measure_check_point(check_point[:name]) if @performance_checker
      result
    end
  end
  
#  def run_check_point(check_point_name, level = 1, &block)
#    add_check_point(check_point_name, level)
#    result = yield
#    measure_check_point(check_point_name)
#    result
#  end
  
end
