require 'test_helper'

describe Service::CategoryGroupsController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'service_category_groups_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"service_category_groups_index\\\"/
    end
    
    describe 'service category group table' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'service_category_group_table')

        xhr :get, :index, :accept => 'text/html'
        @response.body.html_safe.must_be :=~, /table id=\\\"service_category_group_table\\\"/
      end
      
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'service_category_group_filtr') do |filtr|
          assert_select('select[id=?]', 'service_category_group_filtr_operator_id')
          assert_select('select[id=?]', 'service_category_group_filtr_tarif_class_id')
        end
      end
      
      it 'controller must have service_category_group_filtr method of Filtrable type' do
        @controller.must_respond_to :service_category_group_filtr
        @controller.service_category_group_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter service_category_group_filtr records" do
        get :index, 'service_category_group_filtr' => {'operator_id' => 1025 }
        assert_response :success 
        assert_select('table[id=?]', 'service_category_group_table')

      end      
    end
    
    describe 'service_category_tarif_classes' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id*=?]', 'service_category_tarif_class_table')
        if Service::CategoryTarifClass.count > 0
          assert_select('tr[current_id_name=service_category_tarif_class_id]')
        end
      end
      
      it 'must filtr when service_category_group_raw is changed' do
        get :index
        assert :success
        count_before = @controller.service_category_tarif_classes.model.count
        if count_before > 1
          raw_id_before = @controller.service_category_tarif_classes.model.first.id
          next_raw_id = @controller.service_category_tarif_classes.model.last.id
          get :index, 'current_id' => {'service_category_group_id' => next_raw_id }
          assert :success
          next_raw_id.must_be :!=, raw_id_before
        end
      end
    end
    
  end
      
end
