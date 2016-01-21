class Comparison::OptimizationsController < ApplicationController
  include Comparison::OptimizationsHelper, Customer::HistoryParsersBackgroundHelper
  helper Comparison::OptimizationsHelper, Customer::HistoryParsersBackgroundHelper
  include Crudable
  crudable_actions :all
  before_action :check_current_id_exists, only: [:show]
  before_action :set_back_path, only: [:show]
  before_action :validate_tarifs, only: [:show, :update_comparison_results]
  after_action :set_run_id, only: :show
      
  def calculation_status
    if !background_process_informer.calculating?   
      redirect_to comparison_optimization_path(params[:id])
    end
  end
  
  def generate_calls_for_optimization
    calculate_on_back_ground(true, Comparison::Optimization.where(:id => params[:id]), :generate_calls, false)
  end

  def calculate_optimizations
    calculation_options = {:only_new => true, :test => false, :update_comparison => false, :tarifs => []}
    calculate_on_back_ground(true, Comparison::Optimization.where(:id => params[:id]), :calculate_optimizations, calculation_options)
  end

  def update_optimizations
    tarifs = session_filtr_params(tarifs_to_update_comparison)["tarifs"] || []
    calculation_options = {:only_new => true, :test => false, :update_comparison => true, :tarifs => tarifs}
    calculate_on_back_ground(true, Comparison::Optimization.where(:id => params[:id]), :calculate_optimizations, calculation_options)
  end

  def update_comparison_results
    calculate_on_back_ground(true, Comparison::Optimization.where(:id => params[:id]), :update_comparison_results)
  end

  def calculate_on_back_ground(if_calculate_on_back_ground, object_to_run, method_to_run, *arg)
    if if_calculate_on_back_ground
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init(0, 100)
      Spawnling.new(:argv => "calculating comparison: #{method_to_run.to_s}") do
        object_to_run.send(method_to_run, *arg)
        background_process_informer.finish
      end    
      redirect_to comparison_calculation_status_path(params[:id])
    else
      result_of_update = object_to_run.send(method_to_run, *arg)
      redirect_to comparison_optimization_path(params[:id]), :notice => "#{method_to_run.to_s} executed: #{result_of_update}"
    end
  end

end
