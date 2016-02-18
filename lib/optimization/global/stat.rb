class Optimization::Global::Stat < Optimization::Global::Base
  
  def initialize(options = {})
    super
  end
  
  def test_all_global_categories_stat
    calls = Customer::Call.where(:call_run_id => 553)
    all_global_categories_stat(calls, [213])
#    all_global_categories_stat_sql(calls, [674], 'day', true)
  end
  
  def cost_by_part_by_service(part, service_id, categories_stat)
    
  end
  
  def all_global_categories_stat(calls, service_ids = [])
    loaded_service_categories = load_service_categories_by_global_category(service_ids)
    global_stat = detailed_global_categories_stat(calls, loaded_service_categories, service_ids)
    aggregated_global_categories_stat(calls, loaded_service_categories, global_stat, service_ids)
    global_stat
  end
  
  def aggregated_global_categories_stat(calls, loaded_service_categories, global_stat, service_ids = [])
    detailed = false
    ['day', 'month'].each do |group_period|
      sql = all_global_categories_stat_sql(calls, service_ids, group_period, detailed).map{|global_name, r| r.to_sql if r }.compact.join(" union all ")
      calls.find_by_sql(sql).each do |row|
        next if row.global_name.blank?
        global_stat[row.global_name]["aggregated"][row.day] = row.attributes.except("global_name", 'month', 'day')
        
        category_ids_with_filtr = global_stat[row.global_name]["with_filtr"].keys.flatten
        category_ids_with_false_filtr = global_stat[row.global_name]["with_false_filtr"].keys.flatten - category_ids_with_filtr
        global_stat[row.global_name].extract!("with_false_filtr")
#        raise(StandardError, global_stat[row.global_name].keys)
        category_ids_without_filtr = loaded_service_categories[row.global_name].map{|sc| sc.id} - category_ids_with_filtr - category_ids_with_false_filtr
        next if category_ids_without_filtr.blank?
        global_stat[row.global_name]["without_filtr"][category_ids_without_filtr] ||= {}
        global_stat[row.global_name]["without_filtr"][category_ids_without_filtr][row.day] = row.attributes.except("global_name", 'month', 'day')
      end if !sql.blank?
    end
  end
  
  def detailed_global_categories_stat(calls, loaded_service_categories, service_ids = [])
    result = {}
    detailed = true
    ['day', 'month'].each do |group_period|
      sql = all_global_categories_stat_sql(calls, service_ids, group_period, detailed).map{|global_name, r| r.to_sql if r }.compact.join(" union all ")
      calls.find_by_sql(sql).each do |row|
        next if row.global_name.blank?
        service_categories_by_global_category = loaded_service_categories[row.global_name]        
        category_ids_with_filtr = category_ids_for_global_category_stat(service_categories_by_global_category, service_ids, row["filtr_params"])
        result[row.global_name] ||= {"with_filtr" => {}, "with_false_filtr" => {}, "without_filtr" => {}, "aggregated" => {}}
        if !category_ids_with_filtr[true].blank?
          result[row.global_name]["with_filtr"][category_ids_with_filtr[true]] ||= {}
          result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][row.day] = row.attributes.except("global_name", 'month', 'day', 'filtr_params')
        end
        if !category_ids_with_filtr[false].blank?
          result[row.global_name]["with_false_filtr"][category_ids_with_filtr[false]] ||= {}
        end
      end if !sql.blank?
    end
    result 
  end
  
  def category_ids_for_global_category_stat(service_categories_by_global_category, service_ids = [], global_category_filtr = nil)
    result = {true => [], false => []}
    service_categories_by_global_category.each do |sc|
      if global_category_filtr and sc.filtr
#        raise(StandardError, [global_category_filtr, sc.filtr]) if sc.id == 36146
        if Optimization::Global::Base::CategoryFiltr.new.filtr_for_stat(global_category_filtr, sc.filtr)
          result[true] << sc.id 
        else
          result[false] << sc.id
        end
      end
    end      
    result
  end
  
  def load_service_categories_by_global_category(service_ids = [])
    result = {}
    base_service_category = Service::CategoryTarifClass.where.not(:uniq_service_category => [nil, ''])
    base_service_category = base_service_category.includes(:as_standard_category_group).
      joins(:as_standard_category_group).where(:service_category_groups => {:tarif_class_id => service_ids}) if !service_ids.blank?
    base_service_category.find_each do |sc|
      next if sc.uniq_service_category.blank?
      result[sc.uniq_service_category] ||= [] 
      result[sc.uniq_service_category] << sc
    end
    result
  end
  
  def all_global_categories_stat_sql(calls, service_ids = [], group_period = 'month', detailed = false)
    result = {}
    standard_stat_params = ["count(*) as call_id_count"]
    stat_params_grouped_by_period(service_ids).map do |global_name, stat_params|
      params = params_from_global_name(global_name)
      next if stat_params[group_period].blank?
      result[global_name] = one_global_category_stat_sql(calls, stat_params[group_period] + standard_stat_params, params, group_period, detailed)
    end
    result
  end    
  
  def one_global_category_stat_sql(calls, stat_params, params, group_period = 'month', detailed = false)
    cat_name = "('#{global_name(params)}')::text as global_name"
    period_fields = group_period == 'month' ? ['-1 as day', "description->>'month' as month"] : 
      ["description->>'day' as day", "description->>'month' as month"]
    fields = [[cat_name] + period_fields + [stat_params_as_json(stat_params)]] + (detailed ? [stat_params_as_json(call_group.fields_with_name(params), 'filtr_params')] : [])
    fields = fields.join(", ") 
    where_hash = call_filtr.filtr(params)
    group_by = (['day', 'month'] + (detailed ? call_group.group_fields(params) : [])).join(', ')
    calls.select(fields).where(where_hash).group(group_by)#.group(group_period)
  end
  
  def stat_params_as_json(stat_params, name = 'stat_params')
    items = []
    stat_params.each do |stat_param|
      parts = stat_param.split(' as ')
      items << "'#{parts[1]}'" << parts[0]
    end
    "json_build_object(#{items.join(', ')}) as #{name}"
  end

  def stat_params_grouped_by_period(service_ids = [])
    result = {}
    stat_params_by_global_category(service_ids).each do |stat_params_by_global_category|
      result[stat_params_by_global_category["uniq_service_category"]] ||= {'day' => [], 'month' => []}
      stat_params_by_global_category["arr_of_stat_params"].each do |stat_param|
        stat_param.each do |name, desc|        
          group = (desc and desc["group_by"] and desc["group_by"] == 'day') ? 'day' : 'month'
          result[stat_params_by_global_category["uniq_service_category"]][group] << "#{desc['formula']} as #{name}"
        end
      end
    end
    result
  end
  
  def stat_params_by_global_category(service_ids = [], id = nil)
    base_service_category = service_ids.blank? ? Service::CategoryGroup : Service::CategoryGroup.where(:tarif_class_id => service_ids)
    base_service_category.where.not(:service_category_tarif_classes => {:uniq_service_category => [nil, '']}).
#      where(:service_category_tarif_classes => {:id => id}).
      joins(:service_category_tarif_classes, price_lists: [formulas: :standard_formula]).
      select(:uniq_service_category, "array_agg(distinct stat_params) as arr_of_stat_params").
      group(:uniq_service_category)
  end
    
  def global_name(params)
    structure_name.name(params)
  end
  
  def params_from_global_name(global_name)
    structure_name.params_from_name(global_name)
  end  
  
end
