# == Schema Information
#
# Table name: service_category_groups
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  operator_id    :integer
#  tarif_class_id :integer
#  criteria       :json
#  created_at     :datetime
#  updated_at     :datetime
#

class Service::CategoryGroup < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  belongs_to :operator, :class_name =>'::Category', :foreign_key => :operator_id
  belongs_to :tarif_class, :class_name =>'::TarifClass', :foreign_key => :tarif_class_id
  has_many :service_category_tarif_classes, :class_name =>'Service::CategoryTarifClass', :foreign_key => :as_standard_category_group_id
  
end

