module TarifClassesHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers

  def tarif_class_filtr
    create_filtrable("tarif_class")
#    raise(StandardError, session[:filtr])
  end

 def tarif_class_form
    create_formable(TarifClass.where(:id => (params[:id] || session[:current_id]['tarif_class_id'])).first)
  end

  def tarif_classes
#    raise(StandardError, session[:filtr])
    filtr = session_filtr_params(tarif_class_filtr)
    category = filtr.extract!('dependency_parts')['dependency_parts'] #(filtr.extract!('dependency_parts')['dependency_parts'] || []) - ['']
    where_for_category = category.blank? ? "true" : "(dependency->>'parts')::jsonb ?& array['#{category}']"
    
    is_archived = filtr.extract!('dependency_is_archived')['dependency_is_archived']
    where_for_is_archived = case is_archived
      when is_archived.blank?
        "true"
      when 'false' 
        "(dependency->>'is_archived')::boolean = false or (dependency->>'is_archived') is null"
      when 'true'
        "(dependency->>'is_archived')::boolean = true"
      end 
    
    where_not_blank = "features is not null"  
    options = {:base_name => 'tarif_classes', :current_id_name => 'tarif_class_id', :pagination_per_page => 10}
    create_tableable(TarifClass.query_from_filtr(filtr).where(where_for_category).where(where_for_is_archived).where(where_not_blank), options)
  end

  def full_category_groups(filtr = :fixed)
    return @full_category_groups[filtr] if @full_category_groups.try(:filtr)
    @full_category_groups ||= {}
    @full_category_groups[filtr] = Service::CategoryGroup.
      includes(service_category_tarif_classes: [:service_category_rouming, :service_category_geo, :service_category_partner_type,
        :service_category_calls, :service_category_one_time, :service_category_periodic]).
      includes(service_category_tarif_classes: [service_category_calls: [:parent_call]]).
      includes(price_lists: [formulas: [:standard_formula]]).
      where(filtr_condition(filtr)).
      where(:tarif_class_id => (params[:id] || session[:current_id]['tarif_class_id'])).
      order("service_category_tarif_classes.service_category_one_time_id").
      order("service_category_tarif_classes.service_category_periodic_id").
      order("service_category_groups.id").
      order("service_categories.parent_id").
      order("service_category_tarif_classes.service_category_rouming_id, service_category_tarif_classes.service_category_calls_id, service_category_tarif_classes.service_category_geo_id, service_category_tarif_classes.service_category_partner_type_id").
      order("price_formulas.calculation_order")
  end
  
  def filtr_condition(filtr = :fixed)
    base_filtr = "(service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb is null"
    fixed_filtr = "service_category_tarif_classes.service_category_one_time_id is not null or service_category_tarif_classes.service_category_periodic_id is not null"
    included_in_tarif = "price_formulas.standard_formula_id = any('{#{Price::StandardFormula::Const::MaxVolumesForFixedPriceConst.join(', ')}}')"
    case filtr
    when :fixed
      [base_filtr, fixed_filtr]
    when :included_in_tarif
      [base_filtr, "not (#{fixed_filtr})",included_in_tarif]
    when :others
      [base_filtr, "not (#{fixed_filtr})", "not (#{included_in_tarif})"]
    else
      [base_filtr]
    end.map{|f| "(#{f})"}.join(" and ")
  end

  def category_groups
    options = {:base_name => 'category_groups', :current_id_name => 'category_group_id', :pagination_per_page => 10}
    create_tableable(Service::CategoryGroup.where(:tarif_class_id => session[:current_id]['tarif_class_id']), options)
  end

  def service_categories
    options = {:base_name => 'service_categories', :current_id_name => 'service_categories_id', :pagination_per_page => 10}
    create_tableable(Service::CategoryTarifClass.
      includes(:service_category_rouming, :service_category_geo, :service_category_partner_type, :service_category_calls, :service_category_one_time, :service_category_periodic).
      where(:as_standard_category_group_id => session[:current_id]['category_group_id']).
      order("conditions->>'tarif_set_must_include_tarif_options' DESC"). 
      order(:as_standard_category_group_id, :service_category_calls_id, :service_category_rouming_id, :service_category_geo_id), options )
  end

  def price_formulas
    options = {:base_name => 'price_formulas', :current_id_name => 'price_formula_id', :pagination_per_page => 10}
    create_tableable(Price::Formula.joins(price_list: :service_category_group).where(:service_category_groups => {:id => session[:current_id]['category_group_id']}), options)
  end

  def price_standard_formulas
    options = {:base_name => 'price_standard_formulas', :current_id_name => 'price_standard_formula_id', :pagination_per_page => 10}
    create_tableable(Price::StandardFormula.includes(:price_unit, :volume, :volume_unit).joins(:formulas).where(:price_formulas => {:id => session[:current_id]['price_formula_id']}), options)
  end


end
