# == Schema Information
#
# Table name: result_runs
#
#  id                              :integer          not null, primary key
#  name                            :string
#  description                     :text
#  user_id                         :integer
#  call_run_id                     :integer
#  accounting_period               :string
#  optimization_type_id            :integer
#  run                             :integer
#  optimization_params             :jsonb
#  calculation_choices             :jsonb
#  selected_service_categories     :jsonb
#  services_by_operator            :jsonb
#  temp_value                      :jsonb
#  service_choices                 :jsonb
#  services_select                 :jsonb
#  services_for_calculation_select :jsonb
#  service_categories_select       :jsonb
#  categ_ids                       :jsonb
#

class Result::Run < ActiveRecord::Base
  extend BatchInsert
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :call_run, :class_name =>'Customer::CallRun', :foreign_key => :call_run_id
  has_many :tarifs, :class_name =>'Result::Tarif', :foreign_key => :run_id
  has_many :service_sets, :class_name =>'Result::ServiceSet', :foreign_key => :run_id
  has_many :agregates, :class_name =>'Result::Agregate', :foreign_key => :run_id
  has_many :services, :class_name =>'Result::Service', :foreign_key => :run_id
  has_many :service_categories, :class_name =>'Result::ServiceCategory', :foreign_key => :run_id
  has_many :call_stats, :class_name =>'Result::CallStat', :foreign_key => :run_id

#  serialize :calculation_choices, HashSerializer
#  store_accessor :calculation_choices, :blog, :github, :twitter
  
  def full_name
    "#{optimization_type}: #{name}" + (call_run ? " - #{call_run.full_name}" : "")
  end
  
  def optimization_type
    ['Основной', 'Проверка стоимости', 'С ограничением услуг', 'Для одного оператора', 'Со всеми опциями', 'Для администратора'][optimization_type_id] if optimization_type_id
  end

  def self.allowed_new_result_run(user_type = :guest)
    {:guest => 4, :trial => 10, :user => 20, :admin => 100000}[user_type]
  end
  
  def self.allowed_min_result_run(user_type = :guest)
    {:guest => 4, :trial => 5, :user => 5, :admin => 5}[user_type]
  end
  

end

