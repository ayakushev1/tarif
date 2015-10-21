class TarifCreator #ServiceHelper::TarifCreator
  
  attr_reader :options, :operator_id, :tarif_class_id

  def initialize(operator_id, options = {})
    @operator_id = operator_id
    @options = options
  end
  
  def create_tarif_class(tarif_class_values)
    i = 0
    begin
      tarif_class = TarifClass.find_or_create_by(:name => tarif_class_values[:name], :operator_id => operator_id)
    rescue ActiveRecord::RecordNotUnique
      retry if i < 5
      i += 1 
    end    
    @tarif_class_id = tarif_class[:id]
    tarif_class = TarifClass.update(tarif_class[:id], {:operator_id => operator_id}.merge(tarif_class_values) )
  end    
  
  def add_only_service_category_tarif_class(service_category_tarif_class_field_values, condition_when_apply_sctc = {})
    begin
      classified_service_parts = classify_service_parts(service_category_full_paths(service_category_tarif_class_field_values)) 
      parts = classified_service_parts[0]
      parts_criteria = classified_service_parts[1] 
      conditions = {:parts => parts, :parts_criteria => parts_criteria}.merge(condition_when_apply_sctc)

      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :is_active => true}.merge(service_category_tarif_class_field_values).merge(:conditions => conditions)  )
    rescue ActiveRecord::RecordNotUnique
      retry
    ensure
      tarif_category
    end        
  end
  
  def add_one_service_category_tarif_class(service_category_tarif_class_field_values, price_list_field_values, formula_field_values, condition_when_apply_sctc = {})
    begin
      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :is_active => true}.merge(service_category_tarif_class_field_values)  )

      classified_service_parts = classify_service_parts(service_category_full_paths(service_category_tarif_class_field_values)) 
      parts = classified_service_parts[0]
      parts_criteria = classified_service_parts[1] 
      conditions = {:parts => parts, :parts_criteria => parts_criteria}.merge(condition_when_apply_sctc)

      tarif_category = Service::CategoryTarifClass.update(tarif_category[:id], {:conditions => conditions}) 
      
      price = PriceList.create(
        {:service_category_tarif_class_id => tarif_category[:id], :tarif_class_id => tarif_class_id, :is_active => true}.merge(price_list_field_values) )
  
      formulas = Price::Formula.create(
        {:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) )
    rescue ActiveRecord::RecordNotUnique
      retry
    end        
    tarif_category
  end
  
  def add_grouped_service_category_tarif_class(service_category_tarif_class_field_values, standard_category_group_id, condition_when_apply_sctc = {})
      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :as_standard_category_group_id => standard_category_group_id, :is_active => true}.
        merge(service_category_tarif_class_field_values)  )

      classified_service_parts = classify_service_parts(service_category_full_paths(service_category_tarif_class_field_values)) 
      parts = classified_service_parts[0]
      parts_criteria = classified_service_parts[1] 
      conditions = {:parts => parts, :parts_criteria => parts_criteria}.merge(condition_when_apply_sctc)
      tarif_category = Service::CategoryTarifClass.update(tarif_category[:id], {:conditions => conditions}) 
  end
  
  def add_service_category_group(service_category_group_values, price_list_field_values, formula_field_values)
    begin
      service_category_group = Service::CategoryGroup.find_or_create_by(:name => service_category_group_values[:name])
      service_category_group = Service::CategoryGroup.update(service_category_group[:id],
        {:id => service_category_group[:id], :operator_id => operator_id}.merge(service_category_group_values) ) 
  
      price = PriceList.find_or_create_by(:name => price_list_field_values[:name])
      PriceList.update(price[:id],
        {:service_category_group_id => service_category_group[:id], :is_active => true}.merge(price_list_field_values) )
  
      formulas = Price::Formula.find_or_create_by(:name => "formula for #{service_category_group[:name]} order #{( formula_field_values[:calculation_order] || 0 )}")
      Price::Formula.update(formulas[:id],
        {:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) ) 
    rescue ActiveRecord::RecordNotUnique
      retry
    end    
    service_category_group
  end

  def add_tarif_class_categories
    begin
      tarif_class = TarifClass.find(tarif_class_id)
    rescue ActiveRecord::RecordNotFound
      raise(ActiveRecord::RecordNotFound, [tarif_class_id, TarifClass.pluck(:id)] )
      retry
    end    

    classified_service_parts = classify_service_parts(service_category_full_paths(:tarif_class_id => tarif_class_id))
    parts = classified_service_parts[0]
    parts_criteria = classified_service_parts[1]
    dependency = tarif_class[:dependency].merge({:parts => parts, :parts_criteria => parts_criteria} )
    TarifClass.update(tarif_class_id, {:dependency => dependency})    
    
    add_parts_to_service_category_groups(tarif_class_id)
  end

  def add_parts_to_service_category_groups(tarif_class_ids)
    Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).select(:as_standard_category_group_id).distinct.
      pluck(:as_standard_category_group_id).compact.each do |service_category_group_id|
      add_parts_to_service_category_group(service_category_group_id)
    end
  end

  def add_parts_to_service_category_group(service_category_group_id)
    i = 0
    begin
      service_category_group = Service::CategoryGroup.find(service_category_group_id)
    rescue ActiveRecord::RecordNotFound 
      raise(ActiveRecord::RecordNotFound, [service_category_group_id, Service::CategoryGroup.pluck(:id)] ) if i == 5
      i += 1
      retry
    end    

    classified_service_parts = classify_service_parts(service_category_full_paths(:as_standard_category_group_id => service_category_group_id))
    existing_parts = (service_category_group['conditions'] || {})['parts'] || []
    new_parts = classified_service_parts[0]
    parts = {:parts => (existing_parts + new_parts).uniq} 

    existing_parts_criteria = (service_category_group['conditions'] || {})['parts_criteria'] || []
    new_parts_criteria = classified_service_parts[1]
    parts_criteria = {:parts_criteria => (existing_parts_criteria + new_parts_criteria).uniq} 

    Service::CategoryGroup.update(service_category_group_id, 
      {:conditions => (service_category_group['conditions'] || {}).merge(parts).merge(parts_criteria) } )
  end
  
  def service_category_full_paths(where_condition)
    fields = [
      "array_append(rouming.path, rouming.id) as category_rouming_ids",
      "array_append(calls.path, calls.id) as category_calls_ids",
      "array_append(onetime.path, onetime.id) as category_onetime_ids",
      "array_append(periodic.path, periodic.id) as category_periodic_ids",
      ].join(', ')
    Service::CategoryTarifClass.where(where_condition).
    joins('left outer join service_categories rouming on rouming.id =service_category_tarif_classes.service_category_rouming_id').
    joins('left outer join service_categories calls on calls.id =service_category_tarif_classes.service_category_calls_id').
    joins('left outer join service_categories onetime on onetime.id =service_category_tarif_classes.service_category_one_time_id').
    joins('left outer join service_categories periodic on periodic.id =service_category_tarif_classes.service_category_periodic_id').
#    select(fields).distinct.to_sql
    select(fields).distinct.all#pluck(fields)
  end
  
  def classify_service_parts(service_category_full_paths)
    parts = []; parts_criteria = []
    service_category_full_paths.each do |service_category_full_path|
      classified_service_category = classify_service_category(service_category_full_path)
      parts << classified_service_category[0].compact.join('/')
      parts_criteria << classified_service_category[1].compact
    end
#    raise(StandardError, [parts.uniq, parts_criteria.uniq])
    [parts.uniq, parts_criteria.uniq]
  end    

  def classify_service_category(service_category_full_path)
    service_parts = []; service_parts_criteria = {}
    classified_service_category_rouming = classify_service_category_rouming(service_category_full_path['category_rouming_ids'])
    classified_service_category_calls = classify_service_category_calls(service_category_full_path['category_calls_ids'])
    classified_service_category_onetime = classify_service_category_onetime(service_category_full_path['category_onetime_ids'])
    classified_service_category_periodic = classify_service_category_periodic(service_category_full_path['category_periodic_ids'])

    if classified_service_category_calls[0] != :'mms'
      service_parts << classified_service_category_rouming[0]; service_parts_criteria = classified_service_category_rouming[1]
    end 
    service_parts << classified_service_category_calls[0]; service_parts_criteria.merge!(classified_service_category_calls[1])
    service_parts << classified_service_category_onetime[0]; service_parts_criteria.merge!(classified_service_category_onetime[1]) 
    service_parts << classified_service_category_periodic[0]; service_parts_criteria.merge!(classified_service_category_periodic[1]) 

    [service_parts, service_parts_criteria]
  end
  
  def classify_service_category_calls(calls_service_category_full_path)    
    case 
    when calls_service_category_full_path.include?(_sc_calls)
      [:'calls', {:service_category_calls_id => _sc_calls}]
    when calls_service_category_full_path.include?(_sc_sms)
      [:'sms', {:service_category_calls_id => _sc_sms}]
    when calls_service_category_full_path.include?(_sc_mms)
      [:'mms', {:service_category_calls_id => _sc_mms}]
    when calls_service_category_full_path.include?(_sc_mobile_connection)
      [:'mobile-connection', {:service_category_calls_id => [_internet, _wap_internet, _gprs]}]
    else
      [nil, {}]
    end
  end
  
  def classify_service_category_rouming(rouming_service_category_full_path)    
    case 
    when (rouming_service_category_full_path & [_all_russia_rouming, _intra_net_rouming, _sc_national_rouming]).count > 0
      [:'own-country-rouming', {:service_category_rouming_id => _all_russia_rouming}]
    when rouming_service_category_full_path.include?(_all_world_rouming)
      [:'all-world-rouming', {:service_category_rouming_id => _all_world_rouming}]
    else
      [nil, {}]
    end
  end
  
  def classify_service_category_periodic(periodic_service_category_full_path)    
    case 
    when periodic_service_category_full_path.include?(_sc_periodic)
      [:'periodic', {:service_category_periodic_id => [_periodic_monthly_fee, _periodic_day_fee]}]
    else
      [nil, {}]
    end
  end
  
  def classify_service_category_onetime(onetime_service_category_full_path)    
    case 
    when onetime_service_category_full_path.include?(_sc_onetime)
      [:'onetime', {:service_category_one_time_id => _tarif_switch_on}]
    else
      [nil, {}]
    end
  end
  
  
  
end
