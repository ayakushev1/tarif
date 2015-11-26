class Comparison::ResultsController < ApplicationController
  include Comparison::ResultsHelper
  include Crudable
  crudable_actions :all
  
  def generate_calls_for_optimization_list
    if params[:id]
      item = Comparison::Result.where(:id => params[:id]).first
      if item and item.optimization_list_key
#        raise(StandardError, item.optimization_list_key)
        Comparison::Optimization.generate_calls_for_optimization_list([item.optimization_list_key.to_sym])
      end       
    end
    redirect_to comparison_result_path(params[:id]), :notice => "Звонки запущены на расчет"
  end

  def calculate_from_optimization_list
    if params[:id]
      item = Comparison::Result.where(:id => params[:id]).first
      if item and item.optimization_list_key
        Comparison::Optimization.calculate_from_optimization_list([item.optimization_list_key.to_sym])
      end       
    end
    redirect_to comparison_result_path(params[:id]), :notice => "Рейтинг запущен на расчет"
  end

  def update_optimization_result
    if params[:id]
      item = Comparison::Result.where(:id => params[:id].to_i).first
      if item and item.optimization_list_key
        result_of_update = Comparison::Result.compare_best_tarifs_by_operator(item.optimization_list_key.to_sym)
        result_of_update = item.update(:optimization_result => result_of_update)
      end       
    end
    redirect_to comparison_result_path(params[:id]), :notice => "Результаты сравнения обновлены - #{result_of_update}"
  end
  
end
