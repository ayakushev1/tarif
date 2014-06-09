require 'test_helper'

describe ServiceHelper::TarifCreator do
  before do
    @operator_id = _mts
    @tc = ServiceHelper::TarifCreator.new(@operator_id)
  end
  
  it 'must exists' do
    ServiceHelper::TarifCreator.must_be :==, ServiceHelper::TarifCreator
  end
  
  describe 'initialize' do    
    it 'must init repositories' do
      @tc.tarif_classes.model.must_be :==, TarifClass
      @tc.tarif_categories.model.must_be :==, Service::CategoryTarifClass
      @tc.category_groups.model.must_be :==, Service::CategoryGroup 
      @tc.prices.model.must_be :==, PriceList
      @tc.formula.model.must_be :==, Price::Formula      
    end
  end
  
  describe 'create_tarif' do
    it 'must add tarif_class' do
      assert_difference '@tc.tarif_classes.items.size', 1 do
        @tc.create_tarif_class('Smart+')
      end      
    end
    
    it 'must return tarif_class item' do
      @tc.create_tarif_class('smart+')[:name].must_be :==, 'smart+'
#      @tc.tarif_classes.items.must_be :==, 'smart+'
      @tc.tarif_classes.items[@tc.create_tarif_class('smart+')[:id]][:name].must_be :==, 'smart+'
    end
    
    it 'should return existing tarif_class if it exists with the same name' do
      first = @tc.create_tarif_class('smart+')
      @tc.create_tarif_class('smart+')[:id].must_be :==, first[:id]
    end
    
    it 'must set operator_id' do
      @tc.create_tarif_class('smart+')[:operator_id].must_be :==, @operator_id
    end
    
    it 'must set @tarif_class_id to tarifs current_id' do
      new_tarif_class = @tc.create_tarif_class('smart+')
      @tc.tarif_class_id.must_be :==, new_tarif_class[:id]
    end
  end
  
  describe 'add_one_service_category_tarif_class' do
    it 'must add tarif category to tarif' do
      assert_difference '@tc.tarif_categories.items.size + @tc.prices.items.size + @tc.formula.items.size', 3 do
        @tc.add_one_service_category_tarif_class({}, {}, {})
      end
    end
  end
  
  describe 'add_grouped_service_category_tarif_class' do
    it 'must add tarif category to tarif' do
      assert_difference '@tc.tarif_categories.items.size', 1 do
        @tc.add_grouped_service_category_tarif_class({}, 0)
      end
    end
  end
  
  describe 'add_service_category_group' do
    it 'must add service_category_group' do
      assert_difference '@tc.category_groups.items.size + @tc.prices.items.size + @tc.formula.items.size', 3 do
        @tc.add_service_category_group({}, {}, {})
      end
    end

    it 'must add service_category_group with tarif_class_id' do
      new_tarif_class = @tc.create_tarif_class('smart+')
      new_service_category_group = @tc.add_service_category_group({:name => 'new_group'}, {}, {})
      new_service_category_group[:tarif_class_id].must_be :==, new_tarif_class[:id]
    end

    it 'should not add service_category_group with the same name and tarif_class_id' do
      @tc.create_tarif_class('smart+')
      first = @tc.add_service_category_group({:name => 'new_group'}, {}, {})
      
      assert_difference '@tc.category_groups.items.size', 0 do
        @second = @tc.add_service_category_group({:name => 'new_group'}, {}, {})
      end
      first[:id].must_be :==, @second[:id]
    end
  end
  
  describe 'load_repositories' do
    it 'must load all repositories' do
      @tc.create_tarif_class('smart+')
      @tc.add_one_service_category_tarif_class({:name => 'new_group'}, {}, {})
      @tc.add_grouped_service_category_tarif_class({:name => 'new_group_2'}, 0)
      @tc.add_service_category_group({:name => 'new_group'}, {}, {})
      
      sum_to_assert = ['@tc.tarif_classes.model.count', '@tc.tarif_categories.model.count','@tc.category_groups.model.count','@tc.prices.model.count', '@tc.formula.model.count'].join(' + ')
      assert_difference sum_to_assert, 8 do
        @tc.load_repositories
      end
    end

    it 'should no load twice all repositories' do
      @tc.create_tarif_class('smart+')
      @tc.add_one_service_category_tarif_class({:name => 'new_category'}, {:name => 'new_price'}, {:name => 'new_formula'})
      @tc.add_grouped_service_category_tarif_class({:name => 'new_grouped_2'}, 0)
      @tc.add_service_category_group({:name => 'new_group'}, {:name => 'new_price_2'}, {:name => 'new_formula_2'})
      @tc.load_repositories
      @tc.load_repositories
  
      sum_to_assert = ['@tc.tarif_classes.model.count', '@tc.tarif_categories.model.count','@tc.category_groups.model.count','@tc.prices.model.count', '@tc.formula.model.count'].join(' + ')
      assert_difference sum_to_assert, 0 do
        @tc.load_repositories
      end
    end
  end

  describe 'class Repository' do
    before do
      @r = ServiceHelper::TarifCreator::Repository.new(TarifClass)
    end
    
    it 'must exists' do
      ServiceHelper::TarifCreator::Repository.must_be :==, ServiceHelper::TarifCreator::Repository
    end

    describe 'initialize' do
      it 'must create hash repository for model' do
        @r.items.is_a?(Hash).must_be :==, true
      end
      
      it 'must init last id for repository' do
        @r.last_id.must_be :==, (TarifClass.maximum(:id) || -1) 
      end
    end
    
    describe 'find_item_by_name' do
      it 'must find item by name if it exists' do
        @r.items[@r.last_id + 1] = {:id => @r.last_id + 1, :name => 'smart+'}
        @r.find_item_by_name('smart+')[:name].must_be :==, 'smart+'
      end

      it 'must return nil if it do not exist' do
        @r.find_item_by_name('smart+').must_be_nil
      end
    end
    
    describe 'add_item' do
      it 'must add item to repositore' do
        assert_difference '@r.items.size', 1 do
          @r.add_item('smart+')
        end      
      end
      
      it 'must return item' do
        @r.add_item('smart+')[:name].must_be :==, 'smart+'
      end
    end
    
    describe 'add_uniq_item' do
      it 'must add item to repositore' do
        assert_difference '@r.items.size', 1 do
          @r.add_uniq_item('smart+')
        end      
      end
      
      it 'should not add item to repositore if item with name already exists' do
        @r.add_item('smart+')
        assert_difference '@r.items.size', 0 do
          @r.add_uniq_item('smart+')
        end      
      end
      
      it 'must return item' do
        @r.add_uniq_item('smart+')[:name].must_be :==, 'smart+'
      end
    end
    
    describe 'find_item_by_hash' do
      it 'must find item by hash' do
        @r.add_item('smart+')
        @r.items[@r.current_id][:new_key] = 'new_key_value'
        @r.find_item_by_hash({:name => 'smart+', :new_key => 'new_key_value'})[:new_key].must_be :==, 'new_key_value'
      end
      
      it 'must return nil if do not find' do
        @r.add_item('smart+')
        @r.items[@r.current_id][:new_key] = 'new_key_value'
        @r.find_item_by_hash({:name => 'smart+', :new_key => 'wrong_key_value'}).must_be_nil
      end
    end
      
    describe 'load_depository' do
      it 'must load depository to model' do
        first = @r.add_item('smart+')
        assert_difference '@r.model.count', 1, @r.items do
          @r.load_depository
        end
      end
    end
    
    describe 'load_uniq_depository' do
      it 'must load depository to model' do
        @r.add_item('smart+')
        assert_difference '@r.model.count', 1 do
          @r.load_uniq_depository([:name])
        end
      end
  
      it 'should not load depository to model' do
        @r.add_item('smart+')
        @r.load_depository
        assert_difference '@r.model.count', 0 do
          @r.load_uniq_depository([:name])
        end
      end
    end
    
    describe 'delete_items_from_model_that_are_in_depository' do
      it 'must delete depository to model' do
        @r.add_item('smart+')
        @r.load_depository
#        @r.model.delete_all(:id => []).must_be :==, true
        assert_difference '@r.model.count', -1 do
          @r.delete_items_from_model_that_are_in_depository([:name])
        end
      end
    end
    
  end
  
end

