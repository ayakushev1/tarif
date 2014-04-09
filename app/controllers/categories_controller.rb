class CategoriesController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def category_filtr
    Filtrable.new(self, "categories")
  end

  def categories
    s = category_filtr.session_filtr_params
    Tableable.new(self, Category.query_from_filtr(category_filtr.session_filtr_params) )
  end

  def child_categories
    Tableable.new(self, Category.where(:parent_id => session[:current_id]["category_id"]))
  end
end
