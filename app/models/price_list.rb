# == Schema Information
#
# Table name: price_lists
#
#  id                                 :integer          not null, primary key
#  name                               :string(255)
#  tarif_list_id_id                   :integer
#  service_category_group_id_id       :integer
#  service_category_tarif_class_id_id :integer
#  is_active                          :boolean
#  features                           :json
#  description                        :text
#  created_at                         :datetime
#  updated_at                         :datetime
#

class PriceList < ActiveRecord::Base
  include WhereHelper
  belongs_to :tarif_list, :class_name =>'Tarif', :foreign_key => :tarif_list_id
  belongs_to :service_category_group, :class_name =>'Service::CategoryGroup', :foreign_key => :service_category_group_id
  belongs_to :service_category_tarif_class, :class_name =>'Service::CategoryTarifClass', :foreign_key => :service_category_tarif_class_id

end
