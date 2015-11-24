class Comparison::ResultsController < ApplicationController
  include Comparison::ResultsHelper
  include Crudable
  crudable_actions :all
  
  def update_optimization_result
    if params[:id]
      item = Comparison::Result.where(:id => params[:id]).first
      if item and item.optimization_list_key
        item.update(:optimization_result => Comparison::Result.compare_best_tarifs_by_operator(item.optimization_list_key.to_sym))
      end       
    end
    redirect_to comparison_result_path(params[:id]), :notice => "Результаты сравнения обновлены"
  end
  
  
end
