class CategoriesController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def category_filtr
    create_filtrable("categories")
  end

  def categories
    s = session_filtr_params(category_filtr)
    create_tableable(Category.query_from_filtr(session_filtr_params(category_filtr)) )
  end

  def child_categories
    create_tableable(Category.where(:parent_id => session[:current_id]["category_id"]))
  end
end
