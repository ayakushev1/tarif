class Optimization::TarifsCostCalculator
  attr_reader :tarif_results, :formula_params
  attr_reader :optimizator
  
  def initialize(optimizator = nil, options = {})
    @optimizator = optimizator || Optimization::Runner.new().optimizator
    @options = (options)
    @tarif_results = {}
  end
  
  def calculate_tarifs_cost_by_tarif(tarif_id)    
    @formula_params = service_category_tarif_classes_and_formula_params(tarif_list_generator.service_packs[tarif_id])
    tarif_list_generator.tarif_sets[tarif_id].each do |part, tarif_sets_by_part|
      tarif_sets_by_part.each do |tarif_set_id, services|
        tarif_results[tarif_set_id] ||= {}; tarif_results[tarif_set_id][part] ||= {};
        
      end
#      raise(StandardError, tarif_list_generator.tarif_sets)
    end
  end
  
  def calculate_tarif_results(tarif_set)
    
  end
  
  def service_category_tarif_classes_and_formula_params(service_ids)
    result = {}
    service_category_tarif_classes_and_formula_params_sql(service_ids).find_each do |item|
      result[item.part] ||= {}
      result[item.part][item.service_id] ||= {}
      result[item.part][item.service_id][item.service_category_group_id] ||= {}
      result[item.part][item.service_id][item.service_category_group_id][item.calculation_order] ||= []
      result[item.part][item.service_id][item.service_category_group_id][item.calculation_order] << item.attributes.
        except("part", "service_id", "service_category_group_id", "calculation_order")
    end
    result
  end
    
  
  def service_category_tarif_classes_and_formula_params_sql(service_ids)
    fields = [
      "service_category_groups.id",
      "service_category_groups.id as service_category_group_id",
      "service_category_groups.tarif_class_id as service_id",
      'service_category_tarif_classes.uniq_service_category as uniq_service_category',
      "service_category_tarif_classes.conditions#>>'{parts, 0}' as part",
      "service_category_tarif_classes.conditions#>>'{tarif_set_must_include_tarif_options, 0}' as tarif_set_must_include_tarif_options",
      'price_formulas.calculation_order',
      "price_formulas.standard_formula_id",
      "price_formulas.formula#>>'{params}' as params",
      "price_formulas.formula#>>'{window_over}' as window_over",
    ]
    Service::CategoryGroup.where(:tarif_class_id => service_ids).
      joins(:service_category_tarif_classes, price_lists: :formulas).select(fields).
      order("price_formulas.calculation_order, service_category_groups.id, service_category_tarif_classes.id")
  end

  def tarif_list_generator
    optimizator.tarif_list_generator
  end
  
end
