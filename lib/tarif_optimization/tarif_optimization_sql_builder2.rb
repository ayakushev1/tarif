module TarifOptimization::TarifOptimizationSqlBuilder2
  def calculate_tarif_set_sql_for_tarif_sets(operator, tarif_sets_for_tarif)
    raise(StandardError, tarif_sets_for_tarif["all-world-rouming/sms"])
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
 
 tarif_sets(tarif_class_id).each |part, tarif_sets_by_parts|
   tarif_sets_by_parts.each do |service_id|
     select 
   end
 end
 
 
 
  
=end