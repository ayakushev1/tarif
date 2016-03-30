class Service::CategoriesController < ApplicationController
  include Crudable
  crudable_actions :index
  
  def service_category_filtr
    create_filtrable("service_categories")
  end

  def service_categories
    sql = "
      WITH recursive parent(id, name, type_id, parent_id, level, parents, depth) as (
       SELECT id, name, type_id, parent_id, level, array[s.parent_id], 1 FROM service_categories s 
      union all
        select f.id, f.name, f.type_id, f.parent_id, f.level, (f.parents || s.parent_id), (f.depth + 1) from service_categories s, parent f where s.id = f.parents[f.depth]
      )  
      SELECT p.id, p.name, p.type_id, p.parent_id, p.level, parents[1:depth-1] as parents, array_agg(c.name) FROM parent p left join service_categories c on array[c.id] <@ parents where parents[depth] is null
      group by p.id, p.name, p.type_id, p.parent_id, p.level, parents, depth "

#    create_tableable(Service::Category.find_by_sql(sql) )
    create_tableable(Service::Category.query_from_filtr(session_filtr_params(service_category_filtr)) )
  end

  def child_service_categories
    create_tableable(Service::Category.where(:parent_id => session[:current_id]["service_category_id"].to_i))
  end

  def service_criteria
    create_tableable(Service::Criterium.where(:service_category_id => session['current_id']['child_service_category_id'].to_i) )
  end

end
