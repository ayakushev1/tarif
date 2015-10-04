require 'test_helper'

describe PriceListsController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'price_lists_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"price_lists_index\\\"/
    end
    
    describe 'price_lists_index table' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'price_list_table')

        xhr :get, :index, :accept => 'text/html'
        @response.body.html_safe.must_be :=~, /table id=\\\"price_list_table\\\"/
      end
      
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'price_list_filtr') do |filtr|
          assert_select('select[id=price_list_filtr_tarif_class_id]')
          assert_select('select[id=price_list_filtr_tarif_list_id]')
          assert_select('select[id=price_list_filtr_service_category_group_id]')
          assert_select('select[id=price_list_filtr_is_active]')
        end
      end
      
      it 'controller must have Price_list_filtr method of Filtrable type' do
        @controller.must_respond_to :price_list_filtr
        @controller.price_list_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter price_list_filtr records" do
        get :index, 'price_lists_filtr' => {'tarif_list_id' => 1238 }
        assert_response :success 
        assert_select('table[id=?]', 'price_list_table')

      end      
    end
    
    describe 'price_lists' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id*=?]', 'price_list_table')
        if PriceList.count > 0
          assert_select('tr[current_id_name=price_list_id]')
        end
      end
      
      it 'must filtr when filtr is changed' do
        get :index
        assert :success
        count_before = @controller.price_lists.model.count
        if count_before > 0
          last_raw = @controller.price_lists.model.last
          get :index, 'price_list_filtr' => {'tarif_list_id' => last_raw.tarif_list_id }
          assert :success
          count_after = @controller.price_lists.model.count
          count_after.must_be :<, count_before
        end
      end

    end
    
  end
      
end
