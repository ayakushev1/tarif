# == Schema Information
#
# Table name: result_call_stats
#
#  id          :integer          not null, primary key
#  run_id      :integer
#  operator_id :integer
#  stat        :jsonb
#

class Result::CallStat < ActiveRecord::Base
  extend BatchInsert
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id

  def calls_stat_array(group_by)
#    group_by = ['rouming', 'service', nil, nil]
    if group_by.blank?
      result = (stat || []).collect{|row| row if row['count'] > 0}.compact
      result = (false ? result.sort_by{|row| row['order']} : result) || []
      result
    else
      i = 0
      result_hash = {}
      (stat || []).each do |row|
        name = {}
        call_types = eval(row['call_types'])
        name['rouming'] = call_types[0] if group_by.include?('rouming')
        name['service'] = call_types[1] if group_by.include?('service')
        name['direction'] = call_types[2] if group_by.include?('direction')
        name['geo'] = call_types[3] if group_by.include?('geo')
        name['operator'] = call_types[4] if group_by.include?('operator')

        name_string = name.keys.collect{|k| name[k] }.compact.join('_') 
        
        result_hash[name_string] ||= name.merge({'name_string' => name_string, 'count' => 0, 'sum_duration' => 0.0, 'count_volume' => 0, 'sum_volume' => 0.0})
        result_hash[name_string]['count'] += row['count'] || 0
        result_hash[name_string]['sum_duration'] += row['sum_duration'] || 0.0
        result_hash[name_string]['count_volume'] += row['count_volume'] || 0
        result_hash[name_string]['sum_volume'] += row['sum_volume'] || 0.0
        i += 1
      end
      
      result = []
      result_hash.each {|name, value| result << value if value['count'] > 0 }
      true ? result.sort_by!{|item| item['name_string']} : result
    end    
  end
  

end

