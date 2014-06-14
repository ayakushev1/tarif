class ServiceHelper::StatFunctionCollector
  attr_reader :tarif_class_ids, :service_stat
  attr_reader :price_standard_formulas, :price_formulas 
  def initialize(tarif_class_ids)
    @tarif_class_ids = tarif_class_ids
    collect_stat
    collect_price_standard_formulas
    collect_price_formulas
  end
  
  def collect_stat
#    raise(StandardError, collect_stat_for_as_service_category_tarif_classes_sql)   

   [
     collect_stat_for_both_service_category_groups_sql,
     collect_stat_for_service_category_tarif_classes_sql, 
     collect_stat_for_as_service_category_tarif_classes_sql,
    ].each do |sql|
     PriceList.find_by_sql(sql). 
      each do |row| 
        r = row.attributes
#        raise(StandardError, r) if r['service_category_group_id'] ==  11

        service_stat[r['price_formula_calculation_order']] ||= {:categories => {}, :category_groups => {:services => {}, :groups => {}}}
        service_stat[r['price_formula_calculation_order']][:categories][r['tarif_class_id']] ||= {}
        service_stat[r['price_formula_calculation_order']][:category_groups][:services][r['tarif_class_id']] ||= {}
        stat = {
          :service_category_group_id => (r['service_category_group_id'] || -1),
          :stat_params => r['stat_params'],
          :price_formula_id => r['price_formula_id'],        
          :service_category_tarif_class_ids => r['service_category_tarif_class_ids'],          
          :price_formula_calculation_order => r['price_formula_calculation_order'],
          :price_lists_id => r['price_lists_id'],
          :service_category_group_ids => ( (service_stat[r['price_formula_calculation_order']][:category_groups][:services][r['tarif_class_id']][:service_category_group_ids] || []) + 
            [r['service_category_group_id'] ] ).compact,
          :tarif_class_ids => [r['tarif_class_id']],
        }
        if r['service_category_group_id']
          service_stat[r['price_formula_calculation_order']][:category_groups][:services][r['tarif_class_id']][r['service_category_group_id'] ] = stat
          
          service_stat[r['price_formula_calculation_order']][:category_groups][:groups][r['service_category_group_id']] ||= {:service_category_tarif_class_ids_by_service_id => {} }
          service_stat[r['price_formula_calculation_order']][:category_groups][:groups][r['service_category_group_id']] = {
            :service_category_group_id => r['service_category_group_id'],
            :stat_params => r['stat_params'],
            :price_formula_id => r['price_formula_id'],
            :price_formula_calculation_order => r['price_formula_calculation_order'],
            :price_lists_id => r['price_lists_id'],
            
            :tarif_class_ids => (service_stat[r['price_formula_calculation_order']][:category_groups][:groups][r['service_category_group_id']][:tarif_class_ids] || []) + 
              [r['tarif_class_id']], 
            :service_category_tarif_class_ids => (service_stat[r['price_formula_calculation_order']][:category_groups][:groups][r['service_category_group_id']][:service_category_tarif_class_ids] || []) +
              r['service_category_tarif_class_ids'], 
            :service_category_tarif_class_ids_by_service_id => service_stat[r['price_formula_calculation_order']][:category_groups][:groups][r['service_category_group_id']][:service_category_tarif_class_ids_by_service_id].
              merge({r['tarif_class_id'] => r['service_category_tarif_class_ids']})
          }
        else
          service_stat[r['price_formula_calculation_order']][:categories][r['tarif_class_id']][r['service_category_tarif_class_ids'][0] ] = stat
        end
      end
    end  
  end
  
  def collect_stat_for_both_service_category_groups_sql
    [
      "with collect_stat_for_both_service_category_groups_sql as",
      "(",
      "(#{collect_stat_for_service_category_groups_sql})",
      "union",
      "(#{collect_stat_for_as_service_category_tarif_classes_for_service_groups_sql})",
      ")",
      "select tarif_class_id, service_category_group_id, stat_params::json, price_formula_id, price_formula_calculation_order, price_lists_id,",
      "array_agg((service_category_tarif_class_id)::integer) as service_category_tarif_class_ids",
      "from collect_stat_for_both_service_category_groups_sql",
      "group by tarif_class_id, service_category_group_id, stat_params, price_formula_id, price_formula_calculation_order, price_lists_id",
      "order by price_formula_calculation_order",      
    ].join(' ')
  end

  def collect_stat_for_service_category_groups_sql
    @service_stat = []
    sql = PriceList.joins(formulas: :standard_formula, service_category_group: :service_category_tarif_classes).
      select("service_category_tarif_classes.tarif_class_id as tarif_class_id", 
            "price_lists.service_category_group_id", 
            "service_category_tarif_classes.id as service_category_tarif_class_id",
            "(price_standard_formulas.formula->>'stat_params')::text as stat_params",
            "price_formulas.id as price_formula_id", 
            "price_formulas.calculation_order as price_formula_calculation_order",
            "price_lists.id as price_lists_id"
        ).
      where(:service_category_tarif_classes =>{:tarif_class_id => tarif_class_ids}).
      where(:price_lists => {:tarif_list_id => nil}).
      where.not(:price_lists =>{:service_category_group_id => nil}).
      where(:price_lists => {:service_category_tarif_class_id => nil}).
      order("price_formulas.calculation_order").to_sql
  end
  
  def collect_stat_for_as_service_category_tarif_classes_for_service_groups_sql
    @service_stat = []
    sql = PriceList.joins(formulas: :standard_formula, service_category_group: {service_category_tarif_classes: :as_service_categories}).
      select("as_service_categories_service_category_tarif_classes.tarif_class_id as tarif_class_id", 
            "price_lists.service_category_group_id as service_category_group_id", 
            "as_service_categories_service_category_tarif_classes.id as service_category_tarif_class_id",
            "(price_standard_formulas.formula->>'stat_params')::text as stat_params",
            "price_formulas.id as price_formula_id", 
            "price_formulas.calculation_order as price_formula_calculation_order",
            "price_lists.id as price_lists_id"
        ).
      where(:as_service_categories_service_category_tarif_classes =>{:tarif_class_id => tarif_class_ids}).
      where(:price_lists => {:tarif_list_id => nil}).
      where.not(:price_lists =>{:service_category_group_id => nil}).
      where(:price_lists => {:service_category_tarif_class_id => nil}).
      order("price_formulas.calculation_order").to_sql
  end
  
  def collect_stat_for_service_category_tarif_classes_sql
    PriceList.joins(:service_category_tarif_class, formulas: :standard_formula).
    select("service_category_tarif_classes.tarif_class_id",
          "price_lists.service_category_group_id", 
          "array_agg((price_lists.service_category_tarif_class_id)::integer) as service_category_tarif_class_ids",
          "(price_standard_formulas.formula->>'stat_params')::json as stat_params",
          "price_formulas.id as price_formula_id",
          "price_formulas.calculation_order as price_formula_calculation_order",
          "price_lists.id as price_lists_id"
      ).
    where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).
    where(price_lists: {:tarif_list_id => nil}).
    where.not(price_lists: {:service_category_tarif_class_id => nil}).
    group("service_category_tarif_classes.tarif_class_id", 
          "price_lists.service_category_group_id", 
          "price_lists.service_category_tarif_class_id", 
          "price_formulas.id", 
          "price_lists.id",
          "(price_standard_formulas.formula->>'stat_params')::text"
          ).
    order("price_formulas.calculation_order").to_sql
  end
  
  def collect_stat_for_as_service_category_tarif_classes_sql
    PriceList.joins(service_category_tarif_class: :as_service_categories, formulas: :standard_formula).
    select("as_service_categories_service_category_tarif_classes.tarif_class_id",
          "price_lists.service_category_group_id", 
          "array_agg((as_service_categories_service_category_tarif_classes.id)::integer) as service_category_tarif_class_ids",
          "(price_standard_formulas.formula->>'stat_params')::json as stat_params",
          "price_formulas.id as price_formula_id",
          "price_formulas.calculation_order as price_formula_calculation_order",
          "price_lists.id as price_lists_id"
      ).
    where(:as_service_categories_service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).
    where(price_lists: {:tarif_list_id => nil}).
    where.not(price_lists: {:service_category_tarif_class_id => nil}).
    group("as_service_categories_service_category_tarif_classes.tarif_class_id", 
          "price_lists.service_category_group_id", 
          "as_service_categories_service_category_tarif_classes.id", 
          "price_formulas.id", 
          "price_lists.id",
          "(price_standard_formulas.formula->>'stat_params')::text"
          ).
    order("price_formulas.calculation_order").to_sql
  end
  
  def price_formulas_string_for_price_list(price_formula_ids)
    price_formula_ids.collect {|price_formula_id| price_formula_string(price_formula_id.to_i) }.join(' + ')
  end
  
  def price_formula_string(price_formula_id)
    standard_formula_id = price_formulas[price_formula_id].standard_formula_id if price_formulas[price_formula_id] 
    price_standard_formulas[standard_formula_id].formula['method'] if standard_formula_id and price_standard_formulas[standard_formula_id]
  end
  
  def price_formula_group_condition(price_formula_id)
    price_formulas[price_formula_id].formula['group_condition'] if price_formulas[price_formula_id] and price_formulas[price_formula_id].formula
  end
  
  def price_formula_window_condition(price_formula_id)
    price_formulas[price_formula_id].formula['window_condition'] if price_formulas[price_formula_id] and price_formulas[price_formula_id].formula
  end
  
  def collect_price_standard_formulas
    @price_standard_formulas = []
    Price::StandardFormula.all.each {|psf| price_standard_formulas[psf.id] = psf }            
  end
  
  def collect_price_formulas
    @price_formulas = {}
    Price::Formula.
      joins(price_list: :service_category_tarif_class).
      where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).all.
      each {|pf| price_formulas[pf.id] = pf }            

    Price::Formula.
      joins(price_list: {service_category_group: :service_category_tarif_classes}).
      where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).all.
      each {|pf| price_formulas[pf.id] = pf }            
  end
  
end
