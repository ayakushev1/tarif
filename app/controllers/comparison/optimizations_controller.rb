class Comparison::OptimizationsController < ApplicationController
  include Comparison::OptimizationsHelper
  include Crudable
  crudable_actions :all
  after_action :set_run_id, only: :show
      
  def generate_calls_for_optimization
    Comparison::Optimization.where(:id => params[:id]).generate_calls

    redirect_to comparison_optimization_path(params[:id]), :notice => "Звонки запущены на расчет"
  end

  def calculate_optimizations
    Comparison::Optimization.where(:id => params[:id]).calculate

    redirect_to comparison_optimization_path(params[:id]), :notice => "Рейтинг запущен на расчет"
  end

  def update_comparison_results
    result_of_update = Comparison::Optimization.where(:id => params[:id]).update_comparison_results

    redirect_to comparison_optimization_path(params[:id]), :notice => "Результаты сравнения обновлены - #{result_of_update}"
  end
  
end
