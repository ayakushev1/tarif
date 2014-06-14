class ServiceHelper::TarifCreator
  
  attr_reader :options, :operator_id, :tarif_class_id

  def initialize(operator_id, options = {})
    @operator_id = operator_id
    @options = options
  end
  
  def create_tarif_class(tarif_class_values)
    begin
      tarif_class = TarifClass.find_or_create_by(:name => tarif_class_values[:name])
    rescue ActiveRecord::RecordNotUnique
      retry
    end    
    tarif_class = TarifClass.update(tarif_class[:id], 
      {:operator_id => operator_id}.merge(tarif_class_values) )
    @tarif_class_id = tarif_class[:id]
  end
  
  def add_one_service_category_tarif_class(service_category_tarif_class_field_values, price_list_field_values, formula_field_values)
    begin
      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :is_active => true}.merge(service_category_tarif_class_field_values) )
      
      price = PriceList.create(
        {:service_category_tarif_class_id => tarif_category[:id], :tarif_class_id => tarif_class_id, :is_active => true}.merge(price_list_field_values) )
  
      formulas = Price::Formula.create(
        {:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) )
    rescue ActiveRecord::RecordNotUnique
      retry
    end    
    
    tarif_category
  end
  
  def add_as_other_service_category_tarif_class(service_category_tarif_class_field_values, as_other_service_category_tarif_class_field_values)
    other_items = Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_id).where(as_other_service_category_tarif_class_field_values)
    raise(StandardError, 'id should not be nil') if other_items.blank?
    
    other_items.each do |other_item|
      begin
        Service::CategoryTarifClass.create( 
          {:tarif_class_id => tarif_class_id, :as_tarif_class_service_category_id => other_item[:id],:is_active => true,
          }.merge(service_category_tarif_class_field_values) )
      rescue ActiveRecord::RecordNotUnique
        retry
      end    
    end
  end
  
  def add_grouped_service_category_tarif_class(service_category_tarif_class_field_values, standard_category_group_id)
    Service::CategoryTarifClass.create(
      {:tarif_class_id => tarif_class_id, :is_active => true, :as_standard_category_group_id => standard_category_group_id}.
      merge(service_category_tarif_class_field_values) )
  end
  
  def add_service_category_group(service_category_group_values, price_list_field_values, formula_field_values)
    begin
      service_category_group = Service::CategoryGroup.find_or_create_by(:name => service_category_group_values[:name])
      service_category_group = Service::CategoryGroup.update(service_category_group[:id],
        {:id => service_category_group[:id], :operator_id => operator_id}.merge(service_category_group_values) ) 
#        {:id => service_category_group[:id], :operator_id => operator_id, :tarif_class_id => tarif_class_id}.merge(service_category_group_values) ) 
  
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
  
end
