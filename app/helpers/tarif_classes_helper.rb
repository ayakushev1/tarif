module TarifClassesHelper

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
      
#    raise(StandardError, [is_archived, sql])
    create_tableable(TarifClass.query_from_filtr(filtr).
      where("(dependency->>'parts')::jsonb @> '#{category}'::jsonb").
      where(where_for_is_archived))
  end

  def price_lists_for_index
    create_tableable(price_list )
  end
  
  def price_lists_for_show_fixed
    options = {:base_name => 'price_lists_for_show_fixed'}
    create_tableable(price_list.
      joins(:service_category_tarif_class).
      where("service_category_group_id is Null and (service_category_one_time_id is not Null or service_category_periodic_id is not Null)"),
      options )
  end
  
  def price_formulas_fixed
    create_tableable(Price::Formula.with_price_list(session[:current_id]['price_lists_for_show_fixed_id']) )
  end
  
  def price_lists_for_show_calls
    options = {:base_name => 'price_lists_for_show_calls', :pagination_per_page => 100}
    create_tableable(price_list.
      joins(:service_category_tarif_class).
      where("service_category_group_id is Null").
      where(:service_category_tarif_classes => {:service_category_calls_id => [301, 302, 303]}).
      order("service_category_tarif_classes.service_category_calls_id").
      order("service_category_tarif_classes.service_category_rouming_id").
      order("service_category_tarif_classes.service_category_geo_id"),
      options )
  end
  
  def price_formulas_calls
    create_tableable(Price::Formula.with_price_list(session[:current_id]['price_lists_for_show_calls_id']) )
  end
  
  def price_lists_for_show_sms_mms
    options = {:base_name => 'price_lists_for_show_sms_mms', :pagination_per_page => 100}
    create_tableable(price_list.
      joins(:service_category_tarif_class).
      where("service_category_group_id is Null").
      where(:service_category_tarif_classes => {:service_category_calls_id => [310, 311, 312, 320, 321, 322]}).
      order("service_category_tarif_classes.service_category_calls_id").
      order("service_category_tarif_classes.service_category_rouming_id").
      order("service_category_tarif_classes.service_category_geo_id"),
      options )
  end
  
  def price_formulas_sms_mms
    create_tableable(Price::Formula.with_price_list(session[:current_id]['price_lists_for_show_sms_mms_id']) )
  end
  
  def price_lists_for_show_internet
    options = {:base_name => 'price_lists_for_show_internet', :pagination_per_page => 100}
    create_tableable(price_list.
      joins(:service_category_tarif_class).
      where("service_category_group_id is Null").
      where(:service_category_tarif_classes => {:service_category_calls_id => [330, 340, 341, 342]}).
      order("service_category_tarif_classes.service_category_calls_id").
      order("service_category_tarif_classes.service_category_rouming_id").
      order("service_category_tarif_classes.service_category_geo_id"),
      options )
  end
  
  def price_formulas_internet
    create_tableable(Price::Formula.with_price_list(session[:current_id]['price_lists_for_show_internet_id']) )
  end
  
  def price_lists_for_show_non_groups
    create_tableable(price_list.where("service_category_group_id is Null") )
  end
  
  def price_formulas
    create_tableable(Price::Formula.with_price_list(session[:current_id]['price_list_id']) )
#    create_tableable(Price::Formula.where(:price_list_id => session[:current_id]['price_list_id']) )
  end
  
  def service_categories_for_groups    
    create_tableable(Service::CategoryTarifClass.
      where(:tarif_class_id => session[:current_id]['tarif_class_id']).
      where("as_standard_category_group_id is not Null").
      order("conditions->>'tarif_set_must_include_tarif_options' DESC"). 
      order(:as_standard_category_group_id, :service_category_calls_id, :service_category_rouming_id, :service_category_geo_id)
      )
#    create_tableable(PriceList.where(:service_category_group_id => service_category_groups_ids) )
#    raise(StandardError, PriceList.where(:service_category_group_id => service_category_groups_ids).to_sql )
  end

  def price_formulas_groups
    as_standard_category_group_id = Service::CategoryTarifClass.where(:id => session[:current_id]['service_category_tarif_class_id']).pluck(:as_standard_category_group_id)[0]
    price_list_id = PriceList.where(:service_category_group_id => as_standard_category_group_id).pluck(:id)[0]
    create_tableable(Price::Formula.with_price_list(price_list_id) )
#    raise(StandardError, price_list_id)
#    create_tableable(Price::Formula.where(:price_list_id => session[:current_id]['price_list_id']) )
  end
  
  def price_list
    PriceList.tarif_class_price_lists(session[:current_id]['tarif_class_id']).
      includes(:service_category_tarif_class, :formulas).
      order("service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options'  DESC")
  end
private

end
