module TarifOptimization::TarifOptimizationSqlBuilder2
  def calculate_tarif_results_through_categories(operator)
    parts = []
    parts_by_tarif = {}
    tarif_list_generator.tarif_sets.values.each {|tarif_set| parts += (tarif_set.keys - parts)} 
    tarifs = tarif_list_generator.tarifs[operator]
    services = tarif_list_generator.all_services

    sql = <<-SQL 
      WITH 
 tarif_sets as (SELECT row_to_json(json_each(JSON('#{tarif_list_generator.tarif_sets.to_json}'))) as tarif_sets),
 tarif_sets_by_tarif as (SELECT tarif_sets->'key' as tarif_id, tarif_sets->'value' as tarif_sets_by_tarif from tarif_sets),
 tarif_set_array as (SELECT *, 
  ARRAY(SELECT json_array_elements_text(tarif_set)) as tarif_set_array,
  array_length(ARRAY(SELECT json_array_elements_text(tarif_set)), 1) as tarif_set_length
  from tarif_set),
 services as ( SELECT 
  tarif_set_array[tarif_set_length - ordinality + 1]::int as service_id, 
  tarif_set_array[tarif_set_length - ordinality + 2:tarif_set_length] as prev_service_ids, 
  tarif_set_array[tarif_set_length - ordinality + 1:tarif_set_length] as cur_service_ids, 
  array_length(tarif_set_array[tarif_set_length - ordinality + 1:tarif_set_length], 1) as cur_service_array_length,
  ordinality  as tarif_set_index,
  * from tarif_set_array, generate_subscripts(tarif_set_array, 1) with ORDINALITY ),
 tarif_class_ids_with_required_services as (
  select tarif_class_id, (conditions->>'tarif_set_must_include_tarif_options')::jsonb as required_service_ids_0 from service_category_tarif_classes
  where (conditions->>'tarif_set_must_include_tarif_options')::jsonb is not null
  group by tarif_class_id, (conditions->>'tarif_set_must_include_tarif_options')::jsonb ),  
 distinct_service_ids as (select
  service_id, part, tarif_set_index, prev_service_ids, cur_service_ids, cur_service_array_length, required_service_ids_0,
  case when tarif_class_ids_with_required_services.required_service_ids_0 is null then 0 else 1 end as add_one_if_required_service_exists from services
  left join tarif_class_ids_with_required_services on tarif_class_ids_with_required_services.tarif_class_id = services.service_id
  group by service_id, part, tarif_set_index, prev_service_ids, cur_service_ids, cur_service_array_length, required_service_ids_0 ),
 distinct_service_category_ids_with_description as (SELECT
  ARRAY[service_category_rouming_id, service_category_geo_id, service_category_partner_type_id, service_category_calls_id, 
  service_category_one_time_id, service_category_periodic_id] as service_category_ids, 
  (conditions->'tarif_set_must_include_tarif_options')::jsonb as required_service_ids,
  distinct_service_ids.*, calculation_order, -1 as service_category_group_id
  from distinct_service_ids 
  left join service_category_tarif_classes on service_category_tarif_classes.tarif_class_id = distinct_service_ids.service_id
  left join price_lists on price_lists.service_category_tarif_class_id = service_category_tarif_classes.id
  left join price_formulas on price_formulas.price_list_id = price_lists.id
  where as_standard_category_group_id is null and (conditions->>'parts') = ('[' || distinct_service_ids.part || ']') and
  case when required_service_ids_0 is null then
    price_formulas.standard_formula_id is null or (price_formulas.standard_formula_id is not null and calculation_order = 0)
  else
    case when (conditions->>'tarif_set_must_include_tarif_options')::jsonb is null then
      price_formulas.standard_formula_id is null or (price_formulas.standard_formula_id is not null and calculation_order = 0 + add_one_if_required_service_exists)
    else
      price_formulas.standard_formula_id is null or (price_formulas.standard_formula_id is not null and calculation_order = 0) and
      ARRAY(SELECT (jsonb_array_elements_text((conditions->'tarif_set_must_include_tarif_options')::jsonb))) <@ prev_service_ids
    end
  end and 
  case when required_service_ids_0 is null then
    tarif_set_index = 1 and cur_service_array_length = 1
  else
    case when (conditions->>'tarif_set_must_include_tarif_options')::jsonb is null then
      tarif_set_index  = 1 and cur_service_array_length = 1
    else
      tarif_set_index  = 2 and cur_service_array_length = 2
    end
  end
  group by
  ARRAY[service_category_rouming_id, service_category_geo_id, service_category_partner_type_id, service_category_calls_id, service_category_one_time_id, service_category_periodic_id], 
  calculation_order,
  (conditions->'tarif_set_must_include_tarif_options')::jsonb,
  service_id, part, tarif_set_index, prev_service_ids, cur_service_ids, cur_service_array_length, required_service_ids_0, add_one_if_required_service_exists,
  calculation_order, service_category_tarif_classes.id
  ),
 distinct_service_category_groups_ids_with_description as (SELECT
  ARRAY[]::int[] as service_category_ids, 
  (conditions->'tarif_set_must_include_tarif_options')::jsonb as required_service_ids,
  distinct_service_ids.*, calculation_order, service_category_tarif_classes.as_standard_category_group_id as service_category_group_id
  from distinct_service_ids 
  left join service_category_tarif_classes on service_category_tarif_classes.tarif_class_id = distinct_service_ids.service_id
  left join price_lists on price_lists.service_category_group_id = service_category_tarif_classes.as_standard_category_group_id
  left join price_formulas on price_formulas.price_list_id = price_lists.id 
  where as_standard_category_group_id is not null and (conditions->>'parts') = ('[' || distinct_service_ids.part || ']') and (
  (conditions->>'tarif_set_must_include_tarif_options')::jsonb is null or (
  (conditions->>'tarif_set_must_include_tarif_options')::jsonb is not null and
  ARRAY(SELECT (jsonb_array_elements_text((conditions->'tarif_set_must_include_tarif_options')::jsonb))) <@ prev_service_ids 
  ) ) and
  case when required_service_ids_0 is null then
    tarif_set_index = 1 and cur_service_array_length = 1
  else
    case when (conditions->>'tarif_set_must_include_tarif_options')::jsonb is null then
      tarif_set_index  = 1 and cur_service_array_length = 1
    else
      tarif_set_index  = 2 and cur_service_array_length = 2
    end
  end
  group by 
  as_standard_category_group_id, calculation_order,
  (conditions->'tarif_set_must_include_tarif_options')::jsonb,
  service_id, part, tarif_set_index, prev_service_ids, cur_service_ids, cur_service_array_length, required_service_ids_0, add_one_if_required_service_exists
  ),
  
joined_output as (
  select * from distinct_service_category_ids_with_description
  union
  select * from distinct_service_category_groups_ids_with_description
  )
  
 select * from joined_output
 order by part, tarif_set_index, calculation_order, service_category_ids
 limit 10000
SQL
    
    raise(StandardError, sql)

    Service::CategoryTarifClass.
      select("distinct on (service_category_rouming_id, service_category_geo_id, service_category_partner_type_id, service_category_calls_id) \
              service_category_tarif_classes.*").
      joins(:tarif_class, :price_list => :formulas). #:group_price_list
      where(:tarif_class => tarifs).where("as_standard_category_group_id is null").
      where("standard_formula_id is not null").
      to_sql
    
    
    
    sql = calculate_service_list_sql(service_list, price_formula_order) 

    fields = [
      'part', 
      'tarif_class_id', 
      'call_ids', 
      'price_value',
      'call_id_count',
      '(price_values::json) as price_values',
      'set_id'
    ]
    
    sql = "with calculate_service_list_sql as (#{sql}) select #{fields.join(', ')} from calculate_service_list_sql" unless sql.blank?

    check_sql(sql, price_formula_order)
    sql
    
  end
end

=begin
select distinct on (
    service_category_rouming_id,
    service_category_geo_id,
    service_category_partner_type_id,
    service_category_calls_id,
    as_standard_category_group_id
  )     
    count(tarif_class_id), 
    as_standard_category_group_id,
    service_category_calls_id,
    service_category_rouming_id,
    service_category_geo_id,
    service_category_partner_type_id, 
    array_agg(tarif_class_id) tarif_class_ids
  from service_category_tarif_classes     

 
 tarif_sets(tarif_class_id).each |part, tarif_sets_by_parts|
   tarif_sets_by_parts.each do |service_id|
     select 
   end
 end
 


SELECT a AS array, s AS subscript, a[s] AS value
FROM (SELECT generate_subscripts(a, 1) AS s, a FROM arrays) fo
  
=end