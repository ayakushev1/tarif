class CategoriesController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def filtr
    Filtrable.new(self, "categories")
  end

  def categories
    s = session[:filtr]["categories_filtr"]
    Tableable.new(self, Category.type(s["type_id"]).level(s["level_id"]) )
  end

  def child_categories
    Tableable.new(self, Category.where(:parent_id => session[:current_id]["category_id"]))
  end
end
