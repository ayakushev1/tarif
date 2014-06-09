class ServiceHelper::TarifCreator
  
  attr_reader :options, :operator_id, :tarif_classes, :tarif_categories, :category_groups, :prices, :formula 
  attr_reader :tarif_class_id, :tarif_category_id, :category_group_id, :price_id, :formulas_id 

  def initialize(operator_id, options = {})
    @operator_id = operator_id
    @options = options
    @tarif_classes = Repository.new(TarifClass)
    @tarif_categories = Repository.new(Service::CategoryTarifClass)
    @category_groups = Repository.new(Service::CategoryGroup)
    @prices = Repository.new(PriceList)
    @formula = Repository.new(Price::Formula)
  end
  
  def create_tarif_class(name)
    tarif_class = tarif_classes.add_uniq_item(name)
    tarif_classes.items[tarif_classes.current_id][:operator_id] = operator_id
    @tarif_class_id = tarif_class[:id]
    tarif_classes.items[tarif_classes.current_id]
  end
  
  def add_one_service_category_tarif_class(service_category_tarif_class_field_values, price_list_field_values, formula_field_values)
    tarif_category = tarif_categories.add_item_by_hash( 
      {:tarif_class_id => tarif_class_id, :is_active => true}.merge(service_category_tarif_class_field_values) )
    
    price = prices.add_item_by_hash(
      {:service_category_tarif_class_id => tarif_category[:id], :tarif_class_id => tarif_class_id, :is_active => true}.merge(price_list_field_values) )

    formulas = formula.add_item_by_hash(
      {:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) )
    
    tarif_category
  end
  
  def add_as_other_service_category_tarif_class(service_category_tarif_class_field_values, as_other_service_category_tarif_class_field_values)
    other_items = tarif_categories.find_all_items_by_hash(as_other_service_category_tarif_class_field_values)
    raise(StandardError, 'id should be nil') if other_items.blank?
#    raise(StandardError, [other_items])
    
    other_items.each do |other_item|
      tarif_categories.add_item_by_hash( 
        {:tarif_class_id => tarif_class_id, :as_tarif_class_service_category_id => other_item[:id],:is_active => true,
#         :as_standard_category_group_id =>  other_item[:as_standard_category_group_id],
        }.merge(service_category_tarif_class_field_values) )
    end
  end
  
  def add_grouped_service_category_tarif_class(service_category_tarif_class_field_values, standard_category_group_id)
    tarif_categories.add_item_by_hash(
      {:tarif_class_id => tarif_class_id, :is_active => true, :as_standard_category_group_id => standard_category_group_id}.
      merge(service_category_tarif_class_field_values) )
  end
  
  def add_service_category_group(service_category_group_values, price_list_field_values, formula_field_values)
    service_category_group = category_groups.add_uniq_item(service_category_group_values[:name])
    category_groups.items[category_groups.current_id] = 
      {:id => service_category_group[:id], :operator_id => operator_id, :tarif_class_id => tarif_class_id}.merge(service_category_group_values) 

    price = prices.add_item_by_hash(
      {:service_category_group_id => service_category_group[:id], :tarif_class_id => tarif_class_id, :is_active => true}.merge(price_list_field_values) )

    formulas = formula.add_item_by_hash(
      {:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) )
    
    category_groups.items[category_groups.current_id]
  end
  
  def load_repositories
    tarif_class_ids_to_delete = tarif_classes.item_ids_that_are_both_in_model_and_in_depository([:name])
    tarif_class_groups_ids_to_delete = category_groups.item_ids_that_are_both_in_model_and_in_depository([:tarif_class_id, :name])
    unless tarif_class_ids_to_delete.count == 0
      sctc_ids_to_delete = Service::CategoryTarifClass.find_ids_by_tarif_class_ids(tarif_class_ids_to_delete)
      pl_to_delete = PriceList.find_ids_by_tarif_class_ids(tarif_class_ids_to_delete)
      pf_to_delete = Price::Formula.find_ids_by_tarif_class_ids(tarif_class_ids_to_delete)
    end

   unless tarif_class_groups_ids_to_delete.count == 0
    pl_to_delete_g = PriceList.where(:service_category_group_id => tarif_class_groups_ids_to_delete).pluck(:id)
    pf_to_delete_g = Price::Formula.find_ids_by_tarif_class_group_ids(tarif_class_groups_ids_to_delete)
   end

    sql_1 = PriceList.joins(:service_category_tarif_class).where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids_to_delete}).to_sql
    sql_2 = PriceList.joins(service_category_group: :service_category_tarif_classes).where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids_to_delete}).to_sql

#    sql = PriceList.find_ids_by_tarif_class_ids(tarif_class_ids_to_delete)
    sql_g = PriceList.where(:service_category_group_id => tarif_class_groups_ids_to_delete).to_sql
    raise(StandardError, [sql_1, sql_2, pl_to_delete]) if pl_to_delete and pl_to_delete.include?(10)
    raise(StandardError, [sql_g, pl_to_delete_g]) if pl_to_delete_g and pl_to_delete_g.include?(10)
    
    raise(StandardError, [sql_g, pf_to_delete]) if pf_to_delete and pf_to_delete.include?(10)
    raise(StandardError, [sql_g, pf_to_delete_g]) if pf_to_delete_g and pf_to_delete_g.include?(10)

    tarif_classes.model.delete_all(:id => tarif_class_ids_to_delete) 
    tarif_categories.model.delete_all(:id => sctc_ids_to_delete)
    prices.model.delete_all(:id => pl_to_delete)
    formula.model.delete_all(:id => pf_to_delete)

    category_groups.model.delete_all(:id => tarif_class_groups_ids_to_delete)
    prices.model.delete_all(:id => pl_to_delete_g)
    formula.model.delete_all(:id => pf_to_delete_g)
    
    tarif_classes.load_uniq_depository([:name])
    tarif_categories.load_uniq_depository([:id])
    category_groups.load_uniq_depository([:id])
    prices.load_uniq_depository([:id])
    formula.load_uniq_depository([:id])
    
  end
  
  class Repository
    attr_reader :model, :last_id, :current_id, :items
    
    def initialize(model)
      @model = model
      @items = {}
      @last_id = (model.maximum(:id) || -1)
    end
    
    def current_item
      items[current_id]
    end
    
    def add_item(name)
      items[last_id + 1] = {:id => last_id + 1, :name => name}
      @current_id = last_id + 1
      @last_id += 1
      current_item
    end
    
    def add_item_by_hash(hash)
      if hash[:id]
        items[hash[:id]] = hash
        @current_id = hash[:id]
        @last_id += 1 if @last_id <= @current_id 
      else
        items[last_id + 1] = hash.merge({:id => last_id + 1})
        @current_id = last_id + 1
        @last_id += 1
      end
      current_item
    end
    
    def add_uniq_item(name)
      add_item(name) if !find_item_by_name(name) and !find_db_item_by_name(name)
      current_item
    end
    
    def find_item_by_name(name)
      result = nil
      items.each do |key, item|
        if item[:name] == name
          result = item
          @current_id = key
          break 
        end        
      end
      result
    end
    
    def find_db_item_by_name(name)
      item = model.where(:name => name).order(:id).limit(1)
      if item.count > 0 
        hash = {}
        item[0].attributes.each {|key, value| hash[key.to_sym] = value}
        add_item_by_hash(hash)
        raise(StandardError, [item[0], item[0].attributes, @last_id, @current_id]) unless current_item[:id]
        current_item
      else
        nil
      end      
    end
    
    def find_item_by_hash(hash)
      result = nil
      items.each do |item_key, item|
        result = compare_item_with_hash(item, hash)
        break if result
      end
      result
    end
    
    def find_all_items_by_hash(hash)
      result = []
      items.each do |item_key, item|
        result << compare_item_with_hash(item, hash)
      end
      result.compact
    end
    
    def compare_item_with_hash(item, hash)
      item_result = item
      hash.each do |key, value|
        if value != item[key]
          item_result = nil
          break
        end
      end
      item_result
    end
    
    def load_depository
      items_to_load = items.collect{|key, item| item}
      model.transaction do
        model.create(items_to_load)
      end      
    end
    
    def load_uniq_depository(uniq_keys)
      delete_items_from_model_that_are_in_depository(uniq_keys)
      load_depository
    end
    
    def delete_items_from_model_that_are_in_depository(uniq_keys)
      ids_to_delete = item_ids_that_are_both_in_model_and_in_depository(uniq_keys)      
      model.delete_all(:id => ids_to_delete)
    end

    def item_ids_that_are_both_in_model_and_in_depository(uniq_keys)
      filtr_to_delete = item_ids_that_are_both_in_model_and_in_depository_sql(uniq_keys)
      filtr_to_delete.blank? ? [] : model.where(filtr_to_delete).pluck(:id)
    end

    def item_ids_that_are_both_in_model_and_in_depository_sql(uniq_keys)
      filtr = []      
      items.each do |key, item|
        filtr << uniq_keys.collect do |uniq_key|
          unless item[uniq_key].blank?
            if item[uniq_key].is_a?(String)
              "#{uniq_key} = '#{item[uniq_key]}'"
            else
              "#{uniq_key} = #{item[uniq_key]}"
            end
          end                      
        end.compact.join(' and ')
      end
      filtr.collect{|filtr_item| "(#{filtr_item})" unless filtr_item.blank? }.compact.join(' or ')
    end
  end
  
end
