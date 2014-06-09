require 'test_helper'

describe 'Service::CategoryTarifClass' do
  describe 'seed data' do
    it 'active original should have as_standard_category_group_id' do
      Service::CategoryTarifClass.active.original.where.not(:as_standard_category_group_id => nil).count.must_be :==, 0
    end

    it 'active original should have as_tarif_class_service_category_id' do
      Service::CategoryTarifClass.active.original.where.not(:as_tarif_class_service_category_id => nil).count.must_be :==, 0
    end
  end   
  
  describe 'find_ids_by_tarif_class_ids' do
    it 'must return array' do
      Service::CategoryTarifClass.find_ids_by_tarif_class_ids(203).is_a?(Array).must_be :==, true
    end
  end 

end
#  service_category_rouming_id        :integer
#  service_category_geo_id            :integer
#  service_category_partner_type_id   :integer
#  service_category_calls_id          :integer
#  service_category_one_time_id       :integer
#  service_category_periodic_id       :integer
#  as_standard_category_group_id      :integer
#  as_tarif_class_service_category_id :integer
#  tarif_class_service_categories     :integer          default([]), is an Array
#  standard_category_groups           :integer          default([]), is an Array
