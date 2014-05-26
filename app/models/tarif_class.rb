# == Schema Information
#
# Table name: tarif_classes
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  operator_id         :integer
#  privacy_id          :integer
#  standard_service_id :integer
#  features            :json
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#

class TarifClass < ActiveRecord::Base
  include WhereHelper
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id
  belongs_to :privacy, :class_name =>'Category', :foreign_key => :privacy_id
  belongs_to :standard_service, :class_name =>'Category', :foreign_key => :standard_service_id
  has_many :service_category_tarif_classes, :class_name => 'Service::CategoryTarifClass', :foreign_key => :tarif_class_id
  has_many :tarif_lists, :class_name => 'TarifList', :foreign_key => :tarif_class_id

end

