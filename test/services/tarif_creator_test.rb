require 'test_helper'

describe TarifCreator do
  before do
    @operator_id = Category::Operator::Const::Mts
    @tc = TarifCreator.new(@operator_id)
  end
  
  it 'must exists' do
    TarifCreator.must_be :==, TarifCreator
  end
  
  describe 'initialize' do    
    it 'must init repositories' do
    end
  end
  
  describe 'create_tarif' do
    it 'must add tarif_class' do
      assert_difference 'TarifClass.count', 1 do
        @tc.create_tarif_class({:name => 'Smart++'})
      end      
    end
    
    it 'must return tarif_class item' do
      @tc.create_tarif_class({:name => 'Smart+'})[:name].must_be :==, 'Smart+'
    end
    
    it 'should return existing tarif_class if it exists with the same name' do
      first = @tc.create_tarif_class({:name => 'Smart+'})
      @tc.create_tarif_class({:name => 'Smart+'})[:id].must_be :==, first[:id]
    end
    
    it 'must set operator_id' do
      @tc.create_tarif_class({:name => 'Smart+'})[:operator_id].must_be :==, @operator_id
    end
    
    it 'must set @tarif_class_id to tarifs current_id' do
      new_tarif_class = @tc.create_tarif_class({:name => 'Smart+'})
      @tc.tarif_class_id.must_be :==, new_tarif_class[:id]
    end
  end
  
  describe 'add_one_service_category_tarif_class' do
    it 'must add tarif category to tarif' do
      assert_difference 'Service::CategoryTarifClass.count + PriceList.count + Price::Formula.count', 3 do
        @tc.add_one_service_category_tarif_class({}, {}, {})
      end
    end
  end
  
  describe 'add_grouped_service_category_tarif_class' do
    it 'must add tarif category to tarif' do
      assert_difference 'Service::CategoryTarifClass.count', 1 do
        @tc.add_grouped_service_category_tarif_class({}, 0)
      end
    end
  end
  
  describe 'add_service_category_group' do
    it 'must add service_category_group' do
      assert_difference 'Service::CategoryGroup.count + PriceList.count + Price::Formula.count', 3 do
        @tc.add_service_category_group({:name => 'dddd'}, {:name => 'ssss'}, {})
      end
    end

    it 'should not add service_category_group with the same name and tarif_class_id' do
      @tc.create_tarif_class({:name => 'smart+'})
      first = @tc.add_service_category_group({:name => 'new_group'}, {:name => 'ssss'}, {})
      
      assert_difference 'Service::CategoryGroup.count', 0 do
        @second = @tc.add_service_category_group({:name => 'new_group'}, {:name => 'ssss'}, {})
      end
      first[:id].must_be :==, @second[:id]
    end
  end
  
  describe 'add_tarif_class_categories' do
    it 'must update dependency->>category field' do
      @tc.create_tarif_class({:name => 'Smart+', :dependency => {}})
      @tc.add_tarif_class_categories
      TarifClass.find(@tc.tarif_class_id)[:dependency]['categories'].must_be :==, true
    end
  end

end

