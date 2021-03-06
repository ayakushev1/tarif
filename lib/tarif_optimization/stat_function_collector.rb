class TarifOptimization::StatFunctionCollector
  attr_reader :tarif_class_ids, :service_stat, :service_group_stat, :service_group_ids, :service_category_by_group_and_service_id
  attr_reader :price_standard_formulas, :price_formulas, :optimization_params, :tarif_class_parts 
  
  def initialize(tarif_class_ids, optimization_params, operator_id, region_id, if_to_load = true)
    @tarif_class_ids = tarif_class_ids
    @optimization_params = optimization_params
    load_or_calculate_stat(operator_id, region_id, if_to_load)
#    raise(StandardError, tarif_class_parts)
  end
  
  def load_or_calculate_stat(operator_id, region_id, if_to_load)
    if_to_load ? load_stat(operator_id, region_id) : calculate_stat
  end
  
  def calculate_stat
    collect_stat
    collect_price_standard_formulas
    collect_price_formulas
    collect_tarif_class_parts
  end
  
  def load_stat(operator_id, region_id)
    stat_function_collector_saver = Customer::Stat::OptimizationResult.new('preloaded_calculations', 'stat_function_collector', nil)
    loaded_data = stat_function_collector_saver.results({:operator_id => operator_id.to_i, :tarif_id => region_id.to_i})
    return calculate_stat if loaded_data.blank?
#    raise(StandardError)
    
    @service_stat = {}
    loaded_data['service_stat'].each do |part, service_stat_by_part|
      @service_stat[part] ||= {}
      service_stat_by_part.each do |price_formula_calculation_order, service_stat_by_order|
        @service_stat[part][price_formula_calculation_order.to_i] ||= {}
        service_stat_by_order.each do |tarif_class_id, service_stat_by_tarif_class_id|
          @service_stat[part][price_formula_calculation_order.to_i][tarif_class_id.to_i] ||= {}
          service_stat_by_tarif_class_id.each do |service_category_tarif_class_id, service_stat_by_service_category_tarif_class_id|
            @service_stat[part][price_formula_calculation_order.to_i][tarif_class_id.to_i][service_category_tarif_class_id.to_i] = 
              service_stat_by_service_category_tarif_class_id.symbolize_keys
          end if service_stat_by_tarif_class_id
        end if service_stat_by_order
      end if service_stat_by_part
    end if loaded_data['service_stat']
    
    @service_group_stat = {}
    loaded_data['service_group_stat'].each do |part, service_stat_by_part|
      @service_group_stat[part] ||= {}
      service_stat_by_part.each do |price_formula_calculation_order, service_stat_by_order|
        @service_group_stat[part][price_formula_calculation_order.to_i] ||= {}
        service_stat_by_order.each do |service_category_group_id, service_stat_by_service_category_group_id|
          @service_group_stat[part][price_formula_calculation_order.to_i][service_category_group_id.to_i] = service_stat_by_service_category_group_id.symbolize_keys
        end if service_stat_by_order
      end if service_stat_by_part
    end if loaded_data['service_group_stat']
    
    @service_group_ids = {}
    loaded_data['service_group_ids'].each do |part, service_stat_by_part|
      @service_group_ids[part] ||= {}
      service_stat_by_part.each do |price_formula_calculation_order, service_stat_by_order|
        @service_group_ids[part][price_formula_calculation_order.to_i] ||= {}
        service_stat_by_order.each do |tarif_class_id, service_stat_by_tarif_class_id|
          @service_group_ids[part][price_formula_calculation_order.to_i][tarif_class_id.to_i] = service_stat_by_tarif_class_id#.symbolize_keys
        end if service_stat_by_order
      end if service_stat_by_part
    end if loaded_data['service_group_ids']
    
    @service_category_by_group_and_service_id = {}
    loaded_data['service_category_by_group_and_service_id'].each do |part, service_stat_by_part|
      @service_category_by_group_and_service_id[part] ||= {}
      service_stat_by_part.each do |price_formula_calculation_order, service_stat_by_order|
        @service_category_by_group_and_service_id[part][price_formula_calculation_order.to_i] ||= {}
        service_stat_by_order.each do |service_category_group_id, service_stat_by_service_category_group_id|
          @service_category_by_group_and_service_id[part][price_formula_calculation_order.to_i][service_category_group_id.to_i] ||= {}
            service_stat_by_service_category_group_id.each do |tarif_class_id, service_stat_by_tarif_class_id|
              @service_category_by_group_and_service_id[part][price_formula_calculation_order.to_i][service_category_group_id.to_i][tarif_class_id.to_i] = 
                service_stat_by_tarif_class_id#.symbolize_keys
            end if service_stat_by_service_category_group_id
        end if service_stat_by_order
      end if service_stat_by_part
    end if loaded_data['service_category_by_group_and_service_id']
    
    @price_formulas = {}; loaded_data['price_formulas'].map{|k, v| @price_formulas[k.to_i] = v} 
    @price_standard_formulas = {}; loaded_data['price_formulas'].map{|k, v| @price_standard_formulas[k.to_i] = v} 
    @tarif_class_parts = {}; loaded_data['price_formulas'].map{|k, v| @tarif_class_parts[k.to_i] = v}
  end
  
  def collect_stat
    @service_stat = {}; @service_group_stat = {}; @service_group_ids = {}; @service_category_by_group_and_service_id = {}
#    raise(StandardError, collect_stat_for_both_service_category_tarif_classes_sql)   

   [
     collect_stat_for_both_service_category_groups_sql,
     collect_stat_for_both_service_category_tarif_classes_sql,
    ].each do |sql|
     PriceList.find_by_sql(sql). 
      each do |row| 
        r = row#.attributes

        parts = eval(r['parts'])[0]
#        raise(StandardError, [row, nil, parts] ) #if r['service_category_group_id'] ==  11
        service_stat[parts] ||= {}
        service_stat[parts][r['price_formula_calculation_order']] ||= {}
        service_stat[parts][r['price_formula_calculation_order']][r['tarif_class_id']] ||= {}
        service_group_stat[parts] ||= {}
        service_group_stat[parts][r['price_formula_calculation_order']] ||= {}
        service_category_by_group_and_service_id[parts] ||= {}
        service_category_by_group_and_service_id[parts][r['price_formula_calculation_order']] ||= {}
        service_group_ids[parts] ||= {}
        service_group_ids[parts][r['price_formula_calculation_order']] ||= {}
        service_group_ids[parts][r['price_formula_calculation_order']][r['tarif_class_id']] ||= []

        if r['service_category_group_id']
          service_group_ids[parts][r['price_formula_calculation_order']][r['tarif_class_id']] += [r['service_category_group_id'] ]
          service_group_ids[parts][r['price_formula_calculation_order']][r['tarif_class_id']].compact
          
          service_category_by_group_and_service_id[parts][r['price_formula_calculation_order']][r['service_category_group_id']] ||= {}
          service_category_by_group_and_service_id[parts][r['price_formula_calculation_order']][r['service_category_group_id']][r['tarif_class_id']] ||= []
          service_category_by_group_and_service_id[parts][r['price_formula_calculation_order']][r['service_category_group_id']][r['tarif_class_id']] += r['service_category_tarif_class_ids']
          
          service_group_stat[parts][r['price_formula_calculation_order']][r['service_category_group_id']] ||= {}
          service_group_stat[parts][r['price_formula_calculation_order']][r['service_category_group_id']] = {
            :service_category_group_id => r['service_category_group_id'],
            :price_formula_id => r['price_formula_id'],
#            :price_formula_calculation_order => r['price_formula_calculation_order'],
            :price_lists_id => r['price_lists_id'],            
            :tarif_class_ids => (service_group_stat[parts][r['price_formula_calculation_order']][r['service_category_group_id']][:tarif_class_ids] || []) + 
              [r['tarif_class_id']], 
            :service_category_tarif_class_ids => (service_group_stat[parts][r['price_formula_calculation_order']][r['service_category_group_id']][:service_category_tarif_class_ids] || []) +
              r['service_category_tarif_class_ids'], 
          }
        else
          service_stat[parts][r['price_formula_calculation_order']][r['tarif_class_id']][r['service_category_tarif_class_ids'][0] ] = {
            :service_category_group_id => (r['service_category_group_id'] || -1),
            :price_formula_id => r['price_formula_id'],        
            :service_category_tarif_class_ids => r['service_category_tarif_class_ids'],          
#            :price_formula_calculation_order => r['price_formula_calculation_order'],
            :price_lists_id => r['price_lists_id'],
            :tarif_class_ids => [r['tarif_class_id']],
          }
        end
      end
    end  
  end
  
  def collect_stat_for_both_service_category_groups_sql
    [
      "with collect_stat_for_both_service_category_groups_sql as",
      "(",
      "(#{collect_stat_for_service_category_groups_sql})",
      ")",
      "select tarif_class_id, service_category_group_id, stat_params::json, price_formula_id, price_formula_calculation_order, price_lists_id,",
      "array_agg((service_category_tarif_class_id)::integer) as service_category_tarif_class_ids, parts",
      "from collect_stat_for_both_service_category_groups_sql",
      "group by tarif_class_id, service_category_group_id, stat_params, price_formula_id, price_formula_calculation_order, price_lists_id, parts",
      "order by price_formula_calculation_order",      
    ].join(' ')
    
  end

  def collect_stat_for_service_category_groups_sql
#    @service_stat = []
    sql = PriceList.
      joins("inner join price_formulas ON price_formulas.price_list_id = price_lists.id").
      joins("left outer join price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id").
      joins(service_category_group: :service_category_tarif_classes).
      select("service_category_tarif_classes.tarif_class_id as tarif_class_id",
            "price_lists.service_category_group_id", 
            "service_category_tarif_classes.id as service_category_tarif_class_id",
            "coalesce((price_formulas.formula->>'stat_params'), (price_standard_formulas.formula->>'stat_params'))::text as stat_params",
            "price_formulas.id as price_formula_id", 
            "price_formulas.calculation_order as price_formula_calculation_order",
            "price_lists.id as price_lists_id",
            "(service_category_groups.conditions->>'parts') as parts",
        ).
      where(:service_category_tarif_classes =>{:tarif_class_id => tarif_class_ids}).
      where(:price_lists => {:tarif_list_id => nil}).
      where.not(:price_lists =>{:service_category_group_id => nil}).
      where(:price_lists => {:service_category_tarif_class_id => nil}).
      order("price_formulas.calculation_order").to_sql
  end
  
  def collect_stat_for_both_service_category_tarif_classes_sql
    [
      "with collect_stat_for_service_category_tarif_classes_sql as",
      "(",
      "(#{collect_stat_for_service_category_tarif_classes_sql})",
      ")",
      "select tarif_class_id, service_category_group_id, stat_params::json, price_formula_id, price_formula_calculation_order, price_lists_id,",
      "service_category_tarif_class_ids, parts",
      "from collect_stat_for_service_category_tarif_classes_sql",
#      "group by tarif_class_id, service_category_group_id, stat_params, price_formula_id, price_formula_calculation_order, price_lists_id",
      "order by price_formula_calculation_order",      
    ].join(' ')
  end

  def collect_stat_for_service_category_tarif_classes_sql
    PriceList.
    joins("inner join price_formulas ON price_formulas.price_list_id = price_lists.id").
    joins("left outer join price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id").
    joins(:service_category_tarif_class).
    select("service_category_tarif_classes.tarif_class_id",
          "price_lists.service_category_group_id", 
          "array_agg((price_lists.service_category_tarif_class_id)::integer) as service_category_tarif_class_ids",
          "coalesce((price_formulas.formula->>'stat_params'), (price_standard_formulas.formula->>'stat_params'))::text as stat_params",
          "price_formulas.id as price_formula_id",
          "price_formulas.calculation_order as price_formula_calculation_order",
          "price_lists.id as price_lists_id",
          "(service_category_tarif_classes.conditions->>'parts') as parts",
      ).
    where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).
    where(price_lists: {:tarif_list_id => nil}).
    where.not(price_lists: {:service_category_tarif_class_id => nil}).
    group("service_category_tarif_classes.tarif_class_id", 
          "price_lists.service_category_group_id", 
          "price_lists.service_category_tarif_class_id", 
          "price_formulas.id", 
          "price_lists.id",
          "(price_formulas.formula->>'stat_params')::text",
          "(price_standard_formulas.formula->>'stat_params')::text",
          "(service_category_tarif_classes.conditions->>'parts')",
          ).
    order("price_formulas.calculation_order").to_sql
  end
  
  def price_formulas_string_for_price_list(price_formula_ids)
    price_formula_ids.collect {|price_formula_id| price_formula_string(price_formula_id.to_i) }.join(' + ')
  end
  
  def price_formula_string(price_formula_id)
    price_formula = price_formula(price_formula_id)
    price_formula['method'] if price_formula
  end
  
  def price_formula(price_formula_id)
#    raise(StandardError, [1, price_formulas[price_formula_id], price_formulas[price_formula_id].formula] ) if price_formula_id == 60150
    price_formulas[price_formula_id]['formula']
  end
  
  def price_formula_group_condition(price_formula_id)
    if price_formulas[price_formula_id] and price_formulas[price_formula_id]['formula']
      {'group_condition' => price_formulas[price_formula_id]['formula']['group_condition'], 'group_by' => price_formulas[price_formula_id]['formula']['group_by']}
    else
      {}
    end 
  end
  
  def price_formula_window_condition(price_formula_id)
    if price_formulas[price_formula_id] and price_formulas[price_formula_id]['formula']
      {'window_condition' => price_formulas[price_formula_id]['formula']['window_condition'], 'window_over' => price_formulas[price_formula_id]['formula']['window_over']}
    else
      {}
    end 
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
    
    price_formulas.each do |price_formula_id, pf_value|
      if pf_value.standard_formula_id
        @price_formulas[price_formula_id]['formula'] = price_standard_formulas[pf_value.standard_formula_id]['formula'].merge((@price_formulas[price_formula_id]['formula'] || {} ))
        @price_formulas[price_formula_id]['price_unit_id'] = price_standard_formulas[pf_value.standard_formula_id]['price_unit_id']
        @price_formulas[price_formula_id]['volume_id'] = price_standard_formulas[pf_value.standard_formula_id]['volume_id']
        @price_formulas[price_formula_id]['volume_unit_id'] = price_standard_formulas[pf_value.standard_formula_id]['volume_unit_id']
      end      
    end         

    price_formulas.each do |price_formula_id, pf_value|
      formula_option = choose_formula_option_based_on_optimization_params(price_formula_id, optimization_params)
      @price_formulas[price_formula_id]['formula'] = price_formulas[price_formula_id]['formula'][formula_option] if formula_option
    end         

#   price_formula_id = 6015
#   raise(StandardError, [1, price_formulas[price_formula_id] ] )# if price_formula_id == 6016 and key == :internet
  end

  def choose_formula_option_based_on_optimization_params(price_formula_id, optimization_params)
    result =nil
    if price_formulas[price_formula_id] and price_formulas[price_formula_id]['formula']
      [:onetime, :periodic, :calls, :sms, :internet, :common].each do |key|
        price_formula_keys = []; optimization_param_keys = [];
        price_formulas[price_formula_id]['formula'].each{|price_formula_key, price_formula_value| price_formula_keys << price_formula_key.to_s }
        optimization_params[key].each {|optimization_param_key, optimization_param_value| optimization_param_keys << optimization_param_key.to_s}
        
        chosen_params = optimization_param_keys & price_formula_keys
    
        raise(StandardError, [1, price_formulas[price_formula_id], 
          chosen_params, optimization_param_keys, price_formula_keys] ) if price_formula_id == 60150 and key == :internet_
    
        unless chosen_params.blank?
          result = chosen_params[0]
          break
        end
      end
    end
    result
  end
  
  def collect_tarif_class_parts
    @tarif_class_parts = {}
    TarifClass.where(:id => tarif_class_ids).select("id, dependency->>'parts' as parts").all.each do |r|
      tarif_class_parts[r['id']] = eval((r['parts'] || ""))
    end
  end

end
