# == Schema Information
#
# Table name: customer_services
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  phone_number   :string
#  tarif_class_id :integer
#  tarif_list_id  :integer
#  status_id      :integer
#  valid_from     :datetime
#  valid_till     :datetime
#  description    :json
#  created_at     :datetime
#  updated_at     :datetime
#

class Customer::Service < ActiveRecord::Base
  include PgJsonHelper, WhereHelper

  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :tarif_class, :class_name =>'TarifClass', :foreign_key => :tarif_class_id
  belongs_to :tarif_list, :class_name =>'TarifList', :foreign_key => :tarif_class_id
  belongs_to :status, :class_name =>'::Category', :foreign_key => :status_id
  
end
