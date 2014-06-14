class ServiceHelper::MaxPriceFormulaOrderCollector
  attr_reader :tarif_list_generator, :operator_index, :max_order_by_operator, :max_order_by_service, :max_order_by_price_list

  def initialize(tarif_list_generator, operator_index)
    @tarif_list_generator = tarif_list_generator
    @operator_index = operator_index
    @max_order_by_operator = calculate_max_order_by_operator
    @max_order_by_service = calculate_max_order_by_service
    @max_order_by_price_list = calculate_max_order_by_price_list
  end
  
  def calculate_max_order_by_operator
    operator_id = tarif_list_generator.operators[operator_index]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: {service_category_tarif_class: :tarif_class}).
    where(:tarif_classes => {:operator_id => operator_id}).
    maximum(:calculation_order)

    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: {service_category_tarif_classes: :tarif_class}}).
    where(:tarif_classes => {:operator_id => operator_id}).
    maximum(:calculation_order)
    
    [(max_by_service_category_tarif_class || 0), (max_by_service_category_group || 0)].max
  end
  
  def calculate_max_order_by_service
    service_ids = tarif_list_generator.all_services[operator_index]
    max_by_service_category_tarif_class = Price::Formula.joins(price_list: :service_category_tarif_class ).
      where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
      group("service_category_tarif_classes.tarif_class_id").
      maximum(:calculation_order)

    max_by_service_category_group = Price::Formula.joins(price_list: {service_category_group: :service_category_tarif_classes}).
      where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
      group("service_category_tarif_classes.tarif_class_id").
      maximum(:calculation_order)
    
    result = {}
    (max_by_service_category_tarif_class.keys + max_by_service_category_group.keys + service_ids).uniq.each do |key|
      result[key] = [(result[key] || -1), (max_by_service_category_tarif_class[key] || -1), (max_by_service_category_group[key] || -1)].max
    end
    raise(StandardError, [Price::Formula.joins(price_list: :service_category_tarif_class ).
      where(:service_category_tarif_classes => {:tarif_class_id => service_ids}).
      group("service_category_tarif_classes.tarif_class_id").to_sql]) if result.blank?
    result
  end
  
  def calculate_max_order_by_price_list
    service_ids = tarif_list_generator.all_services[operator_index]
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
  
end
