class ServiceHelper::StatFunctionCollector
  attr_reader :tarif_class_ids, :service_stat
  attr_reader :price_standard_formulas, :price_formulas 
  def initialize(tarif_class_ids)
    @tarif_class_ids = tarif_class_ids
    collect_stat_for_service_category_groups
    collect_stat_for_service_category_tarif_classes
    collect_price_standard_formulas
    collect_price_formulas
  end
  
  def collect_stat_for_service_category_groups
    @service_stat = {}
    sql_1 = PriceList.joins(formulas: :standard_formula).
      select("price_lists.tarif_class_id", 
            "price_lists.service_category_group_id", 
            "array_agg((price_standard_formulas.formula->>'stat_params')::json) as stat_params",
            "price_formulas.id as price_formula_id"
        ).
      where(price_lists: {:tarif_class_id => tarif_class_ids}).
      where(price_lists: {:tarif_list_id => nil}).
      where.not(price_lists: {:service_category_group_id => nil}).
      group("price_lists.tarif_class_id", "price_lists.service_category_group_id", "price_formulas.id").to_sql
        
    sql_2 = PriceList.joins(service_category_group: :service_category_tarif_classes).
      select("price_lists.tarif_class_id", 
            "price_lists.service_category_group_id", 
            "array_agg((service_category_tarif_classes.id)::integer) as service_category_tarif_class_ids").
      where(price_lists: {:tarif_class_id => tarif_class_ids}).
      where(price_lists: {:tarif_list_id => nil}).
      where.not(price_lists: {:service_category_group_id => nil}).
      group("price_lists.tarif_class_id", "price_lists.service_category_group_id").to_sql
        
     sql = [
      "with sql_1 as (#{sql_1}),", 
      "sql_2 as (#{sql_2})",
      "select sql_1.tarif_class_id, sql_1.service_category_group_id, sql_1.stat_params, sql_1.price_formula_id, sql_2.service_category_tarif_class_ids",
      "from sql_1, sql_2",
      "where sql_1.tarif_class_id = sql_2.tarif_class_id and sql_1.service_category_group_id = sql_2.service_category_group_id" 
     ].join(' ')   
        
     PriceList.find_by_sql(sql). 
      each do |row| 
        r = row.attributes
        service_stat[r['tarif_class_id'].to_s] ||= []
        service_stat[r['tarif_class_id'].to_s] << {
        :service_category_group_id => r['service_category_group_id'],
        :stat_params => r['stat_params'],
        :price_formula_id => r['price_formula_id'],
        :service_category_tarif_class_ids => r['service_category_tarif_class_ids'],          
        }
      end  
  end
  
  def collect_stat_for_service_category_tarif_classes
    PriceList.joins(formulas: :standard_formula).
    where(price_lists: {:tarif_class_id => tarif_class_ids}).
    where(price_lists: {:tarif_list_id => nil}).
    where(price_lists: {:service_category_group_id => nil}).
    group("price_lists.tarif_class_id", "price_lists.service_category_tarif_class_id", "price_formulas.id").
    pluck("price_lists.tarif_class_id", 
          "price_lists.service_category_tarif_class_id", 
          "array_agg((price_standard_formulas.formula->>'stat_params')::json) as stat_params",
          "price_formulas.id as price_formula_id"
      ).
    each do |row| 
      service_stat[row[0].to_s] ||= []
      service_stat[row[0].to_s] << {:service_category_group_id => -1, :service_category_tarif_class_ids => [row[1]], :stat_params => row[2], :price_formula_id => row[3] } 
    end 
  end
  
  def price_formulas_string_for_price_list(price_formula_ids)
    price_formula_ids.collect {|price_formula_id| price_formula_string(price_formula_id.to_i) }.join(' + ')
  end
  
  def price_formula_string(price_formula_id)
    standard_formula_id = price_formulas[price_formula_id.to_s].standard_formula_id if price_formulas[price_formula_id.to_s] 
    price_standard_formulas[standard_formula_id].formula['method'] if standard_formula_id and price_standard_formulas[standard_formula_id]
  end
  
  def price_formula_condition(price_formula_id)
    price_formulas[price_formula_id.to_s].formula[:window_condition] if price_formulas[price_formula_id.to_s] and price_formulas[price_formula_id.to_s].formula
  end
  
  def collect_price_standard_formulas
    @price_standard_formulas = []
    Price::StandardFormula.all.each {|psf| price_standard_formulas[psf.id] = psf }            
  end
  
  def collect_price_formulas
    @price_formulas = {}
    Price::Formula.joins(:price_list).where(price_lists: {:tarif_class_id => tarif_class_ids}).all.
      each {|pf| price_formulas[pf.id.to_s] = pf }            
  end
  
end
