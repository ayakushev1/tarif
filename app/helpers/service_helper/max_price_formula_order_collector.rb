class ServiceHelper::MaxPriceFormulaOrderCollector
  attr_reader :tarif_list_generator, :operator, :max_order_by_operator, :max_order_by_service, :max_order_by_price_list
  attr_reader :max_order_by_service_and_part, :max_order_by_price_list_and_part

  def initialize(tarif_list_generator, operator)
    @tarif_list_generator = tarif_list_generator
    @operator = operator
    @max_order_by_operator = calculate_max_order_by_operator
    @max_order_by_service = calculate_max_order_by_service
    @max_order_by_service_and_part = calculate_max_order_by_service_and_part
    @max_order_by_price_list = calculate_max_order_by_price_list
    @max_order_by_price_list_and_part = calculate_max_order_by_price_list_and_part
  end
  
  def calculate_max_order_by_operator
    operator_id = operator#tarif_list_generator.operators[operator_index]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: {service_category_tarif_class: :tarif_class}).
    where(:tarif_classes => {:operator_id => operator_id}).
    maximum(:calculation_order)

    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: {service_category_tarif_classes: :tarif_class}}).
    where(:tarif_classes => {:operator_id => operator_id}).
    maximum(:calculation_order)
    
    [(max_by_service_category_tarif_class || 0), (max_by_service_category_group || 0)].max
  end
  
  def calculate_max_order_by_service
    service_ids = tarif_list_generator.all_services_by_operator[operator]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: :service_category_tarif_class ).
      where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
      group("service_category_tarif_classes.tarif_class_id").
      maximum(:calculation_order)

    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: :service_category_tarif_classes}).
      where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
      group("service_category_tarif_classes.tarif_class_id").
      maximum(:calculation_order)
    
    result = {}
    raise(StandardError, [operator, service_ids]) if !service_ids
    (max_by_service_category_tarif_class.keys + max_by_service_category_group.keys + service_ids).uniq.each do |key|
      result[key] = [(result[key] || -1), (max_by_service_category_tarif_class[key] || -1), (max_by_service_category_group[key] || -1)].max
    end
    raise(StandardError, [Price::Formula.joins(price_list: :service_category_tarif_class ).
      where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
      group("service_category_tarif_classes.tarif_class_id").to_sql]) if result.blank?
    result
  end
  
  def calculate_max_order_by_service_and_part
    service_ids = tarif_list_generator.all_services_by_operator[operator]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: :service_category_tarif_class ).
    where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
    select("service_category_tarif_classes.tarif_class_id as tarif_class_id, service_category_tarif_classes.conditions->>'parts' as parts, max(calculation_order) as max_calculation_order").
    group("service_category_tarif_classes.tarif_class_id, service_category_tarif_classes.conditions->>'parts'").to_sql
    
    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: :service_category_tarif_classes}).
    where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
    select("service_category_tarif_classes.tarif_class_id as tarif_class_id, service_category_tarif_classes.conditions->>'parts' as parts, max(calculation_order) as max_calculation_order").
    group("service_category_tarif_classes.tarif_class_id, service_category_tarif_classes.conditions->>'parts'").to_sql
    
    sql = "(#{max_by_service_category_tarif_class}) union (#{max_by_service_category_group})"

    result = {}
    Price::Formula.find_by_sql(sql).each do |row|
      part = eval(row['parts'])[0]; tarif_class_id = row['tarif_class_id']
      result[part] ||= {}
      result[part][tarif_class_id] = [(result[part][tarif_class_id] || 0), (row['max_calculation_order'] || 0)].max
    end

#    raise(StandardError, [result])
    result
  end





  def calculate_max_order_by_price_list
    service_ids = tarif_list_generator.all_services_by_operator[operator]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: :service_category_tarif_class ).
    where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
    group("price_lists.id").
    maximum(:calculation_order)

    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: :service_category_tarif_classes}).
    where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
    group("price_lists.id").
    maximum(:calculation_order)
    
    result = {}
    (max_by_service_category_tarif_class.keys + max_by_service_category_group.keys).uniq.each do |key|
      result[key] = [(result[key] || 0), (max_by_service_category_tarif_class[key] || 0), (max_by_service_category_group[key] || 0)].max
    end
    result
  end
  
  def calculate_max_order_by_price_list_and_part
    service_ids = tarif_list_generator.all_services_by_operator[operator]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: :service_category_tarif_class ).
    where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
    select("price_lists.id as price_list_id, service_category_tarif_classes.conditions->>'parts' as parts, max(calculation_order) as max_calculation_order").
    group("price_lists.id, service_category_tarif_classes.conditions->>'parts'").to_sql
    
    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: :service_category_tarif_classes}).
    where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
    select("price_lists.id as price_list_id, service_category_tarif_classes.conditions->>'parts' as parts, max(calculation_order) as max_calculation_order").
    group("price_lists.id, service_category_tarif_classes.conditions->>'parts'").to_sql
    
    sql = "(#{max_by_service_category_tarif_class}) union (#{max_by_service_category_group})"

    result = {}
    Price::Formula.find_by_sql(sql).each do |row|
      part = eval(row['parts'])[0]; price_list_id = row['price_list_id']
      result[part] ||= {}
      result[part][price_list_id] = [(result[part][price_list_id] || 0), (row['max_calculation_order'] || 0)].max
    end

#    raise(StandardError, [result])
    result
  end
  
end
