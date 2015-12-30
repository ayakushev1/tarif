module TarifClassesHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers

  def tarif_class_filtr
    create_filtrable("tarif_class")
#    raise(StandardError, session[:filtr])
  end

 def tarif_class_form
    create_formable(TarifClass.where(:id => session[:current_id]['tarif_class_id']).first)
  end

  def tarif_classes
#    raise(StandardError, session[:filtr])
    filtr = session_filtr_params(tarif_class_filtr)
    category = (filtr.extract!('dependency_parts')['dependency_parts'] || []) - ['']
    is_archived = filtr.extract!('dependency_is_archived')['dependency_is_archived']
    where_for_is_archived = case is_archived
      when is_archived.blank?
        "true"
      when 'false' 
        "(dependency->>'is_archived')::boolean = false or (dependency->>'is_archived') is null"
      when 'true'
        "(dependency->>'is_archived')::boolean = true"
      end 
      
    options = {:base_name => 'tarif_classes', :current_id_name => 'tarif_class_id', :pagination_per_page => 10}
    create_tableable(TarifClass.query_from_filtr(filtr).
      where("(dependency->>'parts')::jsonb @> '#{category}'::jsonb").
      where(where_for_is_archived), options)
  end





  def price_lists_for_index1
    options = {:base_name => 'price_lists_for_index', :current_id_name => 'price_lists_for_index_id', :pagination_per_page => 10}
    create_tableable(price_list, options)
  end
  

  def service_categories_for_groups    
    options = {:base_name => 'service_categories_for_groups', :current_id_name => 'service_categories_for_groups_id', :pagination_per_page => 10}
    create_tableable(Service::CategoryTarifClass.
      where(:tarif_class_id => session[:current_id]['tarif_class_id']).
      where("as_standard_category_group_id is not Null").
      order("conditions->>'tarif_set_must_include_tarif_options' DESC"). 
      order(:as_standard_category_group_id, :service_category_calls_id, :service_category_rouming_id, :service_category_geo_id), options
      )
#    create_tableable(PriceList.where(:service_category_group_id => service_category_groups_ids) )
#    raise(StandardError, PriceList.where(:service_category_group_id => service_category_groups_ids).to_sql )
  end

  def price_formulas_groups
    options = {:base_name => 'price_formulas_groups', :current_id_name => 'price_formulas_groups_id', :pagination_per_page => 10}
    as_standard_category_group_id = Service::CategoryTarifClass.where(:id => session[:current_id]['service_category_tarif_class_id']).pluck(:as_standard_category_group_id)[0]
    price_list_id = PriceList.where(:service_category_group_id => as_standard_category_group_id).pluck(:id)[0]
    create_tableable(Price::Formula.with_price_list(price_list_id), options)
#    raise(StandardError, price_list_id)
#    create_tableable(Price::Formula.where(:price_list_id => session[:current_id]['price_list_id']) )
  end
  
  def price_list1
    PriceList.tarif_class_price_lists(session[:current_id]['tarif_class_id']).
      includes(:service_category_tarif_class, :formulas).
      order("service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options'  DESC")
  end


end
