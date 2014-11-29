# == Schema Information
#
# Table name: demo_demands
#
#  id             :integer          not null, primary key
#  customer_id    :integer
#  type_id        :integer
#  info           :json
#  status_id      :integer
#  responsible_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Demo::Demand < ActiveRecord::Base

  belongs_to :customer, :class_name =>'User', :foreign_key => :customer_id
  belongs_to :type, :class_name =>'::Category', :foreign_key => :type_id
  belongs_to :status, :class_name =>'::Category', :foreign_key => :status_id
  belongs_to :responsible, :class_name =>'User', :foreign_key => :responsible_id
  
  validates :info, :customer_id, presence: true
  validates_each :type_id do |record, attr, value|
    record.errors[:base] << 'Тип сообщения не может быть пустым' if value.blank?
  end
  
  validates_each :info do |record, attr, value|
    record.errors[:base] << 'Тема сообщения не может быть пустым' if value and value["title"].empty?
    record.errors[:base] << 'Тело сообщения не может быть пустым' if value and value["message"].empty?
    record.errors[:base] << 'Тело сообщения должно содержать не менее 5 слов' if value and !value["message"].blank? and value["message"].split(' ').size < 5
    record.errors[:base] << 'Тело сообщения должно содержать не более 1000 слов' if value and !value["message"].blank? and value["message"].split(' ').size > 1000
    record.errors[:base] << 'У вас слишком длинные слова, используйте пробелы' if value and !value["message"].blank? and value["message"].split(' ').map(&:length).max > 20
  end
end

