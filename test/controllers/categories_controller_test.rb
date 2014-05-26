require 'test_helper'

describe CategoriesController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'categories_index')
      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"categories_index\\\"/
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'categories_filtr') do |filtr|
          assert_select('select[id=?]', 'categories_filtr_type_id')
          assert_select('select[id=?]', 'categories_filtr_level_id')
        end
      end
      
      it 'controller must have categories method of Filtrable type' do
        @controller.must_respond_to :category_filtr
        @controller.category_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter categories records" do
        get :index, 'category_filtr' => {'type_id' => 3 }
        assert_response :success 
        @controller.categories.model.count.must_be :==, 171

      end      
    end
  end
      
end
