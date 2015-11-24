# == Schema Information
#
# Table name: result_agregates
#
#  id                    :integer          not null, primary key
#  run_id                :integer
#  tarif_id              :integer
#  service_set_id        :string
#  service_category_name :string
#  rouming_ids           :integer          is an Array
#  geo_ids               :integer          is an Array
#  partner_ids           :integer          is an Array
#  calls_ids             :integer          is an Array
#  one_time_ids          :integer          is an Array
#  periodic_ids          :integer          is an Array
#  fix_ids               :integer          is an Array
#  rouming_names         :string           is an Array
#  geo_names             :string           is an Array
#  partner_names         :string           is an Array
#  calls_names           :string           is an Array
#  one_time_names        :string           is an Array
#  periodic_names        :string           is an Array
#  fix_names             :string           is an Array
#  rouming_details       :string           is an Array
#  geo_details           :string           is an Array
#  partner_details       :string           is an Array
#  price                 :float
#  call_id_count         :integer
#  sum_duration_minute   :float
#  sum_volume            :float
#  count_volume          :integer
#  categ_ids             :jsonb
#

class Result::Agregate < ActiveRecord::Base
  extend BatchInsert

  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id
  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id
  
  def self.ids_from_run_and_service_set_ids(service_sets_by_run_ids = {})
    result = where('true')
    service_sets_by_run_ids.each do |run_id, service_set_ids|
      result = result.where(:run_id => run_id, :service_set_id => service_set_ids)
    end
    result
  end
  
  def self.compare_service_sets_of_one_run(service_sets_by_run_ids, fields_to_show = [], group_by = [], comparison_base = 'compare_by_price')    
    result = {}
    heads = {}
    groupped_global_categories = Customer::Call::StatCalculator.new.groupped_global_categories(group_by)
    
    includes(:tarif).ids_from_run_and_service_set_ids(service_sets_by_run_ids).each do |item|
      item.categ_ids.each do |global_category_id|      
        global_category_group_name = Customer::Call::StatCalculator.new.global_category_group_name(global_category_id, group_by)
        result[global_category_group_name] ||= {}
#        service_sets_to_compare.each do |service_set|        
          result[global_category_group_name][item.service_set_id] ||= {}
          heads[item.service_set_id] ||= item.tarif.full_name if item.tarif 
          fields_to_show.collect do |field|
            result[global_category_group_name][item.service_set_id][field] ||={:value => 0.0, :categ_ids => item.categ_ids.size, :volume => 0.0}
            result[global_category_group_name][item.service_set_id][field][:value] += (item[field] || 0.0) / item.categ_ids.size.to_f
            result[global_category_group_name][item.service_set_id][field][:volume] += 
              ([item['sum_duration_minute'], item['sum_volume'], item['count_volume']].compact.map(&:to_f).sum || 0.0) / item.categ_ids.size.to_f
#            raise(StandardError, result[global_category_group_name][item.service_set_id][field]) if result[global_category_group_name][item.service_set_id][field][:value] > 0.0
          end          
#        end
      end
      if true and item.categ_ids.blank? and !(item.periodic_ids + item.fix_ids).compact.blank?
        
        result['fixed'] ||= {}
        result['fixed'][item.service_set_id] ||= {}
        heads[item.service_set_id] ||= item.tarif.full_name if item.tarif
        groupped_global_categories.merge!({'fixed' => {'name_string' => 'zfixed1', 'fixed' => 'Постоянные оплаты'}})

        fields_to_show.collect do |field|
#          result['fixed'][item.service_set_id][field] ||= {'name_string' => '-1', 'fixed' => 'Постоянные оплаты1', :value => 0.0, :categ_ids => item.categ_ids.size, :volume => 0.0}
          result['fixed'][item.service_set_id][field] ||= {:value => 0.0, :categ_ids => item.categ_ids.size, :volume => 0.0}
          result['fixed'][item.service_set_id][field][:value] += (item[field] || 0.0) 
        end
      end
    end
    output = []
    result.each do |global_category_group_name, result_by_category|
      temp = {}
      result_by_category.each do |service_set, result_by_service_set|
        temp[heads[service_set]] = result_by_service_set.values.map do |field| 
          (comparison_base == 'compare_by_cost' ? 
            field[:value].round(0) : 
            (field[:volume] > 0.0 ? (field[:value] / field[:volume]).round(2) : field[:value].round(0))
            )
        end.flatten
      end
      output << groupped_global_categories[global_category_group_name].merge(temp)
    end
#        raise(StandardError, [output].join("\n"))
#        raise(StandardError, [groupped_global_categories].join("\n"))
    result = true ? output.sort_by!{|item| item['name_string']} : output
#    raise(StandardError, result.join("\n\n"))
  end
 
end

