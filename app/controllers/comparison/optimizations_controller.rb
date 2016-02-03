class Comparison::OptimizationsController < ApplicationController
  @new_actions = [:call_stat]
  include Crudable
  crudable_actions :all
  include Comparison::OptimizationsHelper, Customer::HistoryParsersBackgroundHelper
  helper Comparison::OptimizationsHelper, Customer::HistoryParsersBackgroundHelper, Comparison::OptimizationPresenter

  before_filter :check_before_freindly_url, only: [:show]

  before_action :check_current_id_exists, only: [:show]
  before_action :set_back_path, only: [:show]
  before_action :validate_tarifs, only: [:show, :update_comparison_results]

  after_action :set_run_id, only: [:show]
  
  add_breadcrumb I18n.t(:comparison_optimizations_path), :comparison_optimizations_path
      
  def choose_your_tarif_from_ratings
    add_breadcrumb "Рекомендации по выбору выгодного тарифа", comparison_choose_your_tarif_from_ratings_path
    group_ids = [10, 11, 12,  21, 23, 27,  50, 52, 54]
    @group_result_description = Comparison::GroupPresenter.result_description(group_ids)
  end
  
  def show
    add_breadcrumb comparison_optimization_form.model.name, comparison_optimization_path(params[:id])
  end
  
  def call_stat
    comparison = Comparison::Optimization.where(:id => session[:current_id]['comparison_optimization_id']).first
    comparison_group_name = Comparison::Group.where(:id => session[:current_id]['comparison_group_id']).first.try(:name)
    add_breadcrumb "#{comparison.try(:name)}, #{comparison_group_name}", comparison_optimization_path(comparison)
    add_breadcrumb "Статистика звонков", comparison_call_stat_path(params[:id])
  end
  
  def calculation_status
    if !background_process_informer.calculating?   
      redirect_to comparison_optimization_path(params[:id])
    end
  end
  
  def generate_calls_for_optimization
    calculate_on_back_ground(true, Comparison::Optimization.where(id_name => params[:id]), :generate_calls, false)
  end

  def calculate_optimizations
    calculation_options = {:only_new => false, :test => false, :update_comparison => false, :tarifs => []}
    calculate_on_back_ground(true, Comparison::Optimization.where(id_name => params[:id]), :calculate_optimizations, calculation_options)
  end

  def update_selected_optimizations
    tarifs = session_filtr_params(tarifs_to_update_comparison)["tarifs"] || []
    calculation_options = {:only_new => false, :test => false, :update_comparison => true, :tarifs => tarifs}
    calculate_on_back_ground(true, Comparison::Optimization.published, :calculate_optimizations, calculation_options)
  end

  def update_optimizations
    tarifs = session_filtr_params(tarifs_to_update_comparison)["tarifs"] || []
    calculation_options = {:only_new => false, :test => false, :update_comparison => true, :tarifs => tarifs}
    calculate_on_back_ground(true, Comparison::Optimization.where(id_name => params[:id]), :calculate_optimizations, calculation_options)
  end

  def update_comparison_results
    calculate_on_back_ground(true, Comparison::Optimization.where(id_name => params[:id]), :update_comparison_results)
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

  def check_before_freindly_url
    @rating = Comparison::Optimization.friendly.find(params[:id])
    if @rating and request.path != comparison_optimization_path(@rating)
      redirect_to comparison_optimization_path(@rating), :status => :moved_permanently
    end if params[:id]
  end
  
end
