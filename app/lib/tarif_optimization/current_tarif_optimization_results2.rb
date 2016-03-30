module TarifOptimization::CurrentTarifOptimizationResults2
  def process_tarif_results_for_tarif_set(executed_tarif_result_batch_sql)
    executed_tarif_result_batch_sql.each do |stat|
      tarif_class_id = stat['tarif_class_id']
      tarif_set_id = stat['set_id']
      part = stat['part']
      
#      tarif_results_ord[tarif_set_id] ||= {}; tarif_results_ord[tarif_set_id][part] ||= {}; tarif_results_ord[tarif_set_id][part][tarif_class_id] ||= {}
#      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order] = stat
#      tarif_results_ord[tarif_set_id][part][tarif_class_id][price_formula_order]['call_ids'] = flatten_call_ids_as_string(stat['call_ids'])
  
  
      tarif_results[tarif_set_id] ||= {}
      tarif_results[tarif_set_id][part] ||= {}
      
      processed_stat = {}
      if simplify_tarif_results
        processed_stat = stat.attributes.merge({'price_values' => [], 'call_ids'=>[], 'call_id_count' => stat['call_id_count'].to_i}) 
        (stat['price_values'] || []).each do |price_value_item|
          all_stat_call_count_id = price_value_item['all_stat']['call_id_count'].to_i if price_value_item['all_stat'] and price_value_item['all_stat']['call_id_count']
          all_stat = price_value_item['all_stat'].merge({'call_ids'=>[], 'call_id_count' => all_stat_call_count_id}) if price_value_item['all_stat']
          processed_stat['price_values'] << price_value_item.merge({'call_ids'=>[], 'all_stat' => all_stat, 'call_id_count' => price_value_item['call_id_count'].to_i})
        end if true #false
      else
        processed_stat = stat
      end

      if tarif_results[tarif_set_id][part][tarif_class_id].blank?
        tarif_results[tarif_set_id][part][tarif_class_id] = processed_stat              
      else
        tarif_results[tarif_set_id][part][tarif_class_id]['call_id_count'] += processed_stat['call_id_count'] #if tarif_optimizator.output_call_count_to_tarif_results
        tarif_results[tarif_set_id][part][tarif_class_id]['price_value'] += (processed_stat['price_value'] || 0)
        tarif_results[tarif_set_id][part][tarif_class_id]['price_values'] += (processed_stat['price_values'] || [])
      end
  
    end if executed_tarif_result_batch_sql
    
  end
end