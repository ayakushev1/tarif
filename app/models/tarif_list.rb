# == Schema Information
#
# Table name: tarif_lists
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  tarif_class_id :integer
#  region_id      :integer
#  features       :json
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class TarifList < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  belongs_to :tarif_class, :class_name =>'TarifClass', :foreign_key => :tarif_class_id
  belongs_to :region, :class_name =>'Category', :foreign_key => :region_id
  has_many :price_lists, :class_name =>'PriceList', :foreign_key => :tarif_list_id


end

