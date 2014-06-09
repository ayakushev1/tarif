# == Schema Information
#
# Table name: price_formulas
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  price_list_id       :integer
#  calculation_order   :integer
#  standard_formula_id :integer
#  formula             :json
#  price               :decimal(, )
#  price_unit_id       :integer
#  volume_id           :integer
#  volume_unit_id      :integer
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#

class Price::Formula < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  belongs_to :price_list, :class_name =>'::PriceList', :foreign_key => :price_list_id
  belongs_to :standard_formula, :class_name =>'Price::StandardFormula', :foreign_key => :standard_formula_id
  belongs_to :price_unit, :class_name =>'::Category', :foreign_key => :price_unit_id
  belongs_to :volume, :class_name =>'::Parameter', :foreign_key => :volume_id
  belongs_to :volume_unit, :class_name =>'::Category', :foreign_key => :volume_unit_id

  def self.with_price_list(price_list_id)
    !price_list_id.blank? ? where("price_list_id = ?", price_list_id.to_i) : where(false) 
  end
  
  def self.find_ids_by_tarif_class_ids(tarif_class_ids)
    (
    joins(price_list: :service_category_tarif_class).where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).pluck(:id) +
    joins(price_list: {service_category_group: :service_category_tarif_classes}).
      where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).
      where.not(:service_category_groups => {:tarif_class_id => nil}).pluck(:id) 
      ).uniq     
  end
  
  def self.find_ids_by_tarif_class_group_ids(tarif_class_group_ids)
    joins(price_list: :service_category_group).where(:service_category_groups => {:id => tarif_class_group_ids}).uniq.pluck(:id)     
  end
  
end
