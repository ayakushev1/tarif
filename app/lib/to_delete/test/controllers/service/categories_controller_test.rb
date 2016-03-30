require 'test_helper'

describe Service::CategoriesController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'service_categories_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"service_categories_index\\\"/
    end
    
    describe 'service category table' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'service_category_table')

        xhr :get, :index, :accept => 'text/html'
        @response.body.html_safe.must_be :=~, /table id=\\\"service_category_table\\\"/
      end
      
      it 'must link_to service_criteria' do
        if Service::Category.count > 0
          service_category_id = Service::Category.first.id
#          get :index, :category_id => service_category_id, 
        end                
      end
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'service_categories_filtr') do |filtr|
          assert_select('select[id=?]', 'service_categories_filtr_type_id')
          assert_select('select[id=?]', 'service_categories_filtr_level')
        end
      end
      
      it 'controller must have service_category_filtr method of Filtrable type' do
        @controller.must_respond_to :service_category_filtr
        @controller.service_category_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter service_categories records" do
        get :index, 'service_categories_filtr' => {'service_categories_filtr_type_id' => 160 }
        assert_response :success 
        assert_select('table[id=?]', 'service_category_table')

      end      
    end
    
    describe 'service criteria on index page' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'service_criterium_table') do |filtr|
        end
      end
      
    end
    
  end
      
end
