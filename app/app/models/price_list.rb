# == Schema Information
#
# Table name: price_lists
#
#  id                              :integer          not null, primary key
#  name                            :string
#  tarif_class_id                  :integer
#  tarif_list_id                   :integer
#  service_category_group_id       :integer
#  service_category_tarif_class_id :integer
#  is_active                       :boolean
#  features                        :json
#  description                     :text
#  created_at                      :datetime
#  updated_at                      :datetime
#

class PriceList < ActiveRecord::Base
  include WhereHelper
  belongs_to :tarif_class, :class_name =>'TarifClass', :foreign_key => :tarif_class_id
  belongs_to :tarif_list, :class_name =>'TarifList', :foreign_key => :tarif_list_id
  belongs_to :service_category_group, :class_name =>'Service::CategoryGroup', :foreign_key => :service_category_group_id
  belongs_to :service_category_tarif_class, :class_name =>'Service::CategoryTarifClass', :foreign_key => :service_category_tarif_class_id
  has_many :formulas, :class_name =>'Price::Formula', :foreign_key => :price_list_id

  def self.with_tarif_list(tarif_list_id)
    !tarif_list_id.blank? ? where("tarif_list_id = ?", tarif_list_id.to_i) : where(false) 
  end
  
  def self.all_price_lists(tarif_list_id)
    tarif_class_id = TarifList.find(tarif_list_id).tarif_class_id
    where(:id =>  
      (direct_price_lists(tarif_list_id).pluck(:id).uniq +
       tarif_class_price_lists_not_in_direct(tarif_list_id).pluck(:id).uniq +      
       category_group_price_lists_not_in_direct(tarif_list_id).pluck(:id).uniq      
      ).uniq
    )
  end
  
  def self.direct_price_lists(tarif_list_id)
    where(:tarif_list_id => tarif_list_id).exists? ? where(:tarif_list_id => tarif_list_id) : none
  end

  def self.tarif_class_price_lists(tarif_class_id)
    where(:tarif_class_id => tarif_class_id).exists? ? where(:tarif_class_id => tarif_class_id) : none
  end
  
  def self.tarif_class_price_lists_not_in_direct(tarif_list_id)
    tarif_class_id = TarifList.find(tarif_list_id).tarif_class_id
    direct_service_category_tarif_class_ids = direct_price_lists(tarif_list_id).pluck(:service_category_tarif_class_id).uniq

    tarif_class_price_lists(tarif_class_id).where.not(:service_category_tarif_class_id => direct_service_category_tarif_class_ids)
  end

  def self.category_group_price_lists(service_category_group_ids)
    where(:service_category_group_id => service_category_group_ids).exists? ? where(:service_category_group_id => service_category_group_ids) : none
  end

  def self.category_group_price_lists_not_in_direct(tarif_list_id)
    tarif_class_id = TarifList.find(tarif_list_id).tarif_class_id
    operator_id = TarifClass.find(tarif_class_id).operator_id
    service_category_group_ids = Service::CategoryGroup.where(:tarif_class_id => tarif_class_id, :operator_id => operator_id).all#.first
    
#    direct_service_category_tarif_class_ids = direct_price_lists(tarif_list_id).pluck(:service_category_tarif_class_id).uniq
#    tarif_class_price_lists_not_in_direct_ids = tarif_class_price_lists_not_in_direct(tarif_list_id).pluck(:service_category_tarif_class_id).uniq
#    service_category_service_category_tarif_class_ids = category_group_price_lists(service_category_group_id).pluck(:service_category_tarif_class_id).uniq

    category_group_price_lists(service_category_group_ids)#.where.not(:service_category_tarif_class_id => direct_service_category_tarif_class_ids + tarif_class_price_lists_not_in_direct_ids)
  end
  
  def self.find_ids_by_tarif_class_ids(tarif_class_ids)
    (joins(:service_category_tarif_class).where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).pluck(:id) +
    joins(service_category_group: :service_category_tarif_classes).where(:service_category_tarif_classes => {:tarif_class_id => tarif_class_ids}).
      where.not(:service_category_groups => {:tarif_class_id => nil}).pluck(:id) ).
    uniq
  end
  

end
