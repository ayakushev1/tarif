require 'test_helper'

describe ServiceHelper do
  it 'must exists' do
    ServiceHelper::QueryConstructor.must_be :==, ServiceHelper::QueryConstructor
  end
  
  describe 'QueryConstructor class' do
    before do            
      @fq_tarif_operator_id = 1025; @fq_tarif_region_id = 1133; #context variables
      @tarif_class_id = [0, 75, 77, 80, 93]
            
      @q = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => @tarif_class_id})
    end
    
    describe 'init method' do
      it 'must have context attribute' do
        @q.context.must_be :==, self
      end
      
      it 'must load array of comparion operators' do
        @q.comparison_operators[126].must_be :==, 'in'
      end
      
      it 'must load category_ids' do
        @q.category_ids.wont_be_nil 
      end
      
      it 'must load categories' do
        @q.categories.wont_be_nil 
      end
      
      it 'must load criteria_category' do
        @q.criteria_category.wont_be_nil 
      end
      
      it 'must load tarif_class_categories into only with specified ids' do
        tarif_class_id = [0]
        q = ServiceHelper::QueryConstructor.new(self, {:tarif_class_ids => tarif_class_id})
        chosen_tarif_class_categories = q.tarif_class_categories.collect{|tc| tc[0].to_i}
        correct_tarif_class_categories = Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_id).order(:id).pluck(:id)
        (chosen_tarif_class_categories - correct_tarif_class_categories).must_be :==, [], correct_tarif_class_categories
      end
      
      it 'must load load_service_category_tarif_class_ids_by_tarif_class' do
        @q.tarif_class_categories_by_tarif_class.wont_be_nil 
      end
      
      it 'must load load_service_category_group_ids_by_tarif_class' do
        @q.service_category_group_ids_by_tarif_class.must_be_nil 
      end
      
      it 'must load call_ids_by_tarif_class_id' do
        @q.call_ids_by_tarif_class_id[0].wont_be_nil
        @q.call_ids_by_tarif_class_id.flatten.compact.count.must_be :==, Customer::Call.count
      end
      
      describe 'load_parameters' do
        it 'must load array of Parameters' do
          @q.parameters[1].must_be :==, Parameter.find(1)
        end
        
        it 'must accept array of params_ids' do
          q_with_params = ServiceHelper::QueryConstructor.new(self, {:parameter_ids => [0, 1, 2], :criterium_ids => [], :tarif_class_ids => @tarif_class_id})
          q_with_params.parameters[1].wont_be_nil
          q_with_params.parameters[1].must_be :==, Parameter.find(1)
          q_with_params.parameters[3].must_be_nil
        end
      end
      
      describe 'calculate_service_criteria_where_hash' do
        describe 'criterium_where_hash' do
#TODO  copy testing from Service::Criterium class        
        end
        
        it 'must calculate criteria_where_hash and return array of them' do
          @q.criteria_where_hash[10].wont_be_nil
          @q.criteria_where_hash[10].must_be :==, @q.criterium_where_hash(Service::Criterium.find(10))
        end
      end
      
      describe 'calculate_service_category_where_hash' do
        it 'must calculate criteria_where_hash and return array of them' do
#          @q.category_ids.must_be :==, true
#          @q.childs_category[p.id].must_be :==, true
#          @q.categories.must_be :==, true
          @q.categories_where_hash[1].wont_be_nil @q.categories_where_hash
          @q.categories_where_hash[2].must_be :==, "(customer_calls.connect->>'operator_id' = '1025') and (customer_calls.connect->>'region_id' = '1133')" 
          @q.categories_where_hash[302].must_be :==, "(customer_calls.base_service_id = '50') and (customer_calls.base_subservice_id = '71')"
        end 
      end
    end
    
    describe 'calculate tarif_classes_categories_where_hash' do
      describe 'load_required_service_category_tarif_class_ids' do
        it 'must work' do
          first_key = @q.tarif_class_categories.keys.first
          @q.tarif_class_categories[first_key].must_be_kind_of(Service::CategoryTarifClass)
        end        
      end
      
      it 'must calculate initial_tarif_classes_category_where_hash and return array of them' do
        first = Service::CategoryTarifClass.where.not(:service_category_rouming_id => nil).first
        @q.tarif_classes_categories_where_hash[first.id.to_s].wont_be_nil
        @q.tarif_classes_categories_where_hash[first.id.to_s].must_be :==, @q.initial_tarif_classes_category_where_hash(first)
      end
      
#      it 'load_secondary_service_category_tarif_class_ids' do
#        first = Service::CategoryTarifClass.where.not(:as_tarif_class_service_category_id => nil).first
#        original = Service::CategoryTarifClass.find(first.as_tarif_class_service_category_id)
#        @q.tarif_classes_categories_where_hash[first.id.to_s].wont_be_nil
#        @q.tarif_classes_categories_where_hash[first.id.to_s].must_be :==, @q.initial_tarif_classes_category_where_hash(original)
#      end
    end
    
    describe 'category_groups_where_hash' do
      describe 'load category_groups' do
        it 'must work' do
          first_key = @q.category_groups.keys.first
          @q.category_groups[first_key].must_be_kind_of(Service::CategoryGroup)
        end
      end

      describe 'calculate_category_groups_where_hash' do
        it 'must work' do
          first_key = @q.category_groups_where_hash.keys.first
          @q.category_groups_where_hash[first_key].must_be_kind_of(String)
        end
      end
    end
    
    describe 'tarif_classes_category_where_hash' do
      it 'must returm correct values for original records' do
        first = Service::CategoryTarifClass.where('service_category_one_time_id is null and service_category_periodic_id is null').
        active.original.first
        @q.tarif_classes_category_where_hash(first.id).wont_be_nil
        @q.tarif_classes_category_where_hash(first.id).must_be :==, @q.tarif_classes_categories_where_hash[first.id.to_s]
      end

#      it 'must returm correct values for secondary records' do
#        first = Service::CategoryTarifClass.where.not(:as_tarif_class_service_category_id => nil).active.first
#        @q.tarif_classes_category_where_hash(first.id).wont_be_nil
#        @q.tarif_classes_category_where_hash(first.id).must_be :==, @q.tarif_classes_categories_where_hash[first.as_tarif_class_service_category_id.to_s]
#      end

#      it 'must returm correct values for groupped records' do
#        first = Service::CategoryTarifClass.where.not(:as_standard_category_group_id => nil).active.first
#        @q.tarif_classes_category_where_hash(first.id).wont_be_nil
#        @q.tarif_classes_category_where_hash(first.id).must_be :==, @q.category_groups_where_hash[first.as_standard_category_group_id.to_s]
#      end

      it 'must returm correct values for choosen records' do
#        @q.calculate_stat({}).must_be :==, true
#        first = Service::CategoryTarifClass.find(1208100)
#        @q.tarif_classes_category_where_hash(first.id).wont_be_nil @q.category_groups_where_hash.keys#[first.as_standard_category_group_id.to_s]
#        @q.tarif_classes_category_where_hash(first.id).must_be :==, @q.category_groups_where_hash[first.as_standard_category_group_id.to_s]
      end
    end
    
  end

end

