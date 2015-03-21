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

require 'test_helper'

describe 'PriceList' do
  describe 'seed data' do
    it 'must have raws with tarif_list_id not nil' do
      PriceList.where.not(:tarif_list_id => nil).count.must_be :>, 0
    end
    
    it 'must have raws with tarif_class_id not nil' do
      PriceList.where.not(:tarif_class_id => nil).count.must_be :>, 0
    end
    
    it 'must have raws with service_category_group_id not nil' do
      PriceList.where.not(:service_category_group_id => nil).count.must_be :>, 0
    end
    
    it 'should not have records with both tarif_list_id and tarif_class_id and service_category_group_id being not nil' do
      PriceList.where('tarif_list_id > 0 and service_category_group_id > 0').count.must_be :==, 0
      PriceList.where('tarif_list_id > 0 and tarif_class_id > 0').count.must_be :==, 0
      PriceList.where('service_category_group_id > 0 and tarif_class_id > 0').count.must_be :==, 0
    end

    it 'should not have records with both tarif_list_id and tarif_class_id and service_category_group_id being nil' do
      PriceList.where(:tarif_list_id => nil, :tarif_class_id => nil, :service_category_group_id => nil).count.must_be :==, 0
    end
    
    it 'must have __all_loaded_tarifs' do
#      require Rails.root.join('db/seeds/definitions.rb')
#      _all_loaded_tarifs.must_be :==, true
#      TarifClass.where(:id => _all_loaded_tarifs ).count.must_be :==, true
    end
  end
  
  describe 'class methods' do
    before do
      @tarif_list_id = PriceList.where.not(:tarif_list_id => nil).first.tarif_list_id
      @tarif_class_id = TarifList.find(@tarif_list_id).tarif_class_id

      @service_category_group = Service::CategoryGroup.where(:tarif_class_id => @tarif_list_id).all#.first
      @service_category_group_ids = @service_category_group.map{|s| s.id}
    end
    
    describe 'direct_price_lists' do
      it 'must return positive number of raws if direct prices exits' do
        PriceList.direct_price_lists(@tarif_list_id).count.must_be :>, 0
      end
    end
    
    describe 'tarif_class_price_lists' do
      it 'must return price_lists for tarif_class' do
        PriceList.tarif_class_price_lists(@tarif_class_id).count.must_be :>, 0
      end
    end

    describe 'tarif_class_price_lists_not_in_direct' do
      it 'must show service_categories not from direct_price_list' do
        direct_service_category = PriceList.direct_price_lists(@tarif_list_id).pluck(:service_category_tarif_class_id)
        tarif_class_service_category = PriceList.tarif_class_price_lists_not_in_direct(@tarif_list_id).pluck(:service_category_tarif_class_id)
        
        (tarif_class_service_category & direct_service_category).must_be :==, []
      end
    end

    describe 'category_group_price_lists' do
      it 'must return price_lists for category_group' do
        @all_service_category_group = Service::CategoryGroup.all
        @all_service_category_group_ids = @all_service_category_group.map{|s| s.id}
        PriceList.category_group_price_lists(@all_service_category_group).count.must_be :>, 0, @all_service_category_group
      end
    end

    describe 'category_group_price_lists_not_in_direct' do
      it 'must show service_categories not from direct_price_list' do
        direct_service_category = PriceList.direct_price_lists(@tarif_list_id).pluck(:service_category_tarif_class_id)
        category_group_service_category = PriceList.category_group_price_lists_not_in_direct(@tarif_list_id).pluck(:service_category_tarif_class_id)
        
        (category_group_service_category & direct_service_category).must_be :==, []
      end

    end

    describe 'all_price_lists' do
      before do
        @direct_price_list_ids = PriceList.direct_price_lists(@tarif_list_id).pluck(:id)
        @class_price_list_ids = PriceList.tarif_class_price_lists(@tarif_class_id).pluck(:id)
        @category_group_price_list_ids = PriceList.category_group_price_lists(@service_category_group_ids).pluck(:id)
        @all_price_list_ids = PriceList.all_price_lists(@tarif_list_id).pluck(:id)
      end
      
      it 'must return all raws from direct prices' do
        (@direct_price_list_ids - @all_price_list_ids).must_be :==, []
      end

      it 'must return all raws from direct prices' do
        (@category_group_price_list_ids - @all_price_list_ids).must_be :==, []
      end

      it 'must return all price_lists from tarif_list or tarif_class' do
        (@all_price_list_ids - @direct_price_list_ids - @class_price_list_ids - @category_group_price_list_ids).must_be :==, []
      end
    end

    describe 'find_ids_by_tarif_class_ids' do
      it 'must return array' do
        PriceList.find_ids_by_tarif_class_ids(203).is_a?(Array).must_be :==, true
      end
    end 
  
    
  end
end
