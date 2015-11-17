# == Schema Information
#
# Table name: customer_call_runs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  source      :integer
#  description :text
#

class Customer::CallRun < ActiveRecord::Base
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  has_many :calls, :class_name =>'Customer::Call', :foreign_key => :call_run_id
  has_many :call_runs, :class_name =>'Customer::CallRun', :foreign_key => :call_run_id

  def full_name
    "#{source_name}: #{name}"
  end
  
  def source_name
    ['Моделирование', 'Загрузка детализации'][source] if source
  end
end

