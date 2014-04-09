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
#  has_and_belongs_to_many :service_categories, :join_table => ':service_category_tarif_classes', :class_name => 'Service::Category'
#  has_many :children, :class_name =>'Category', :foreign_key => :parent_id

end

