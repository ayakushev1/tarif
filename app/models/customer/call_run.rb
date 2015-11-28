# == Schema Information
#
# Table name: customer_call_runs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  source      :integer
#  description :text
#  operator_id :integer
#  init_class  :string
#  init_params :jsonb
#  stat        :jsonb
#

class Customer::CallRun < ActiveRecord::Base
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id
  has_many :calls, :class_name =>'Customer::Call', :foreign_key => :call_run_id

  def full_name
    "#{source_name}: #{name}"
  end
  
  def source_name
    ['Моделирование', 'Загрузка детализации', 'Сравнение'][source] if source
  end
  
  def self.allowed_new_call_run(user_type = :guest)
    {:guest => 3, :trial => 5, :user => 10, :admin => 100000}[user_type]
  end

  def self.min_new_call_run(user_type = :guest)
    {:guest => 3, :trial => 5, :user => 5, :admin => 5}[user_type]
  end

  
  def self.generate_calls(only_new = true, test = false)
    (only_new ? unloaded_call_runs : all).collect do |call_run|
      call_run.generate_calls(only_new, test)
      call_run.name
    end
  end
  
  def self.generate_group_calls(only_new = true, test = false)
    group_calls = (only_new ? unloaded_call_runs : all)
    return [] if !group_calls.present?

    if test
      group_calls.map(&:id)
    else
      group_calls.first.generate_calls 
      new_call_run_ids = group_calls.map(&:id) - [group_calls.first.id]
      Customer::CallRun.generate_calls_from_one_to_other_operator(group_calls.first.id, new_call_run_ids)
    end
  end
  
  def generate_calls
    return false if !init_params
    calls_generation_params = init_params.symbolize_keys.deep_merge({:general => {"operator_id" => operator_id}})
    user_params = {"call_run_id" => id}
    
    Customer::Call.where(user_params).delete_all
    Calls::Generator.new(calls_generation_params, user_params).generate_calls
  end
  
  def self.generate_calls_from_one_to_other_operator(base_call_id, new_call_run_ids = [])
    base_call = where(:id => base_call_id).first
    if base_call
      where(:id => new_call_run_ids).each do |new_call_run|
        Customer::Call.where({"call_run_id" => new_call_run.id}).delete_all
        Calls::Generator.generate_calls_from_one_to_other_operator(base_call.operator_id, base_call.id, new_call_run.operator_id, new_call_run.id)
      end
    end
  end
  
  def self.loaded_call_run_ids
    Customer::Call.where("user_id is null").pluck(:call_run_id).uniq
  end
  
  def self.unloaded_call_runs
    where("user_id is null").where.not(:id => loaded_call_run_ids)
  end
  
  def calls_stat_array(group_by = [], accounting_period = nil)
    return [] if !stat
    accounting_period = stat.keys[0] if !(accounting_period and stat.keys.include?(accounting_period))
    chosen_stat = stat[accounting_period]
    if group_by.blank?
      result = chosen_stat.collect{|row| row if row['count'] > 0}.compact
      result = (false ? result.sort_by{|row| row['order']} : result) || []
      result
    else
      i = 0
      result_hash = {}
      chosen_stat.each do |row|
        name = {}
        call_types = eval(row['call_types'])
#        raise(StandardError, [row['call_types'], call_types, row])
        name['rouming'] = call_types[0] if group_by.include?('rouming')
        name['service'] = call_types[1] if group_by.include?('service')
        name['direction'] = call_types[2] if group_by.include?('direction')
        name['geo'] = call_types[3] if group_by.include?('geo')
        name['operator'] = call_types[4] if group_by.include?('operator')

        name_string = name.keys.collect{|k| name[k] }.compact.join('_') 
        
        result_hash[name_string] ||= name.merge({'name_string' => name_string, 'categ_ids' => [], 'count' => 0, 'sum_duration' => 0.0, 'count_volume' => 0, 'sum_volume' => 0.0})
        result_hash[name_string]['categ_ids'] += (([row['order']] || []) - result_hash[name_string]['categ_ids'])
        result_hash[name_string]['count'] += row['count'] || 0
        result_hash[name_string]['sum_duration'] += row['sum_duration'] || 0.0
        result_hash[name_string]['count_volume'] += row['count_volume'] || 0
        result_hash[name_string]['sum_volume'] += row['sum_volume'] || 0.0
        i += 1
      end
      
      result = []
      result_hash.each {|name, value| result << value if value['count'] > 0.0 }
      true ? result.sort_by!{|item| item['name_string']} : result
    end
  end
  
  def calculate_call_stat
    @fq_tarif_region_id = 1238
    accounting_periods = Customer::Call.where(:call_run_id => id).pluck("description->>'accounting_period'").uniq
    all_selected_categories = Customer::Info::ServiceCategoriesSelect.default_selected_categories(:admin, {
      :country_roming => true, :intern_roming => true, :mms => true, :internet => true })
    selected_service_categories = Customer::Info::ServiceCategoriesSelect.service_categories_from_selected_services(all_selected_categories)
    
    query_constructor = TarifOptimization::QueryConstructor.new(self, {:tarif_class_ids => [], :performance_checker => false}, (operator_id || 1030), @fq_tarif_region_id, true )
      
    result = {}
    accounting_periods.each do |accounting_period|
      calculator = Customer::Call::StatCalculator.new({:call_run_id => id, :accounting_period => accounting_period}) #, 
      calculator.calculate_calculation_scope(query_constructor, selected_service_categories)
      result[accounting_period] = calculator.calculate_calls_stat(query_constructor)
      
    end
    update(:stat => result)
  end

  
end

