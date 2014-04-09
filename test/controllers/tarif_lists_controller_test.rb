require 'test_helper'

describe TarifListsController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'tarif_lists_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"tarif_lists_index\\\"/
    end
    
    describe 'tarif_lists_index table' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'tarif_list_table')

        xhr :get, :index, :accept => 'text/html'
        @response.body.html_safe.must_be :=~, /table id=\\\"tarif_list_table\\\"/
      end
      
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'tarif_list_filtr') do |filtr|
          assert_select('select[id=?]', 'tarif_list_filtr_tarif_class_id')
          assert_select('select[id=?]', 'tarif_list_filtr_region_id')
        end
      end
      
      it 'controller must have tarif_list_filtr method of Filtrable type' do
        @controller.must_respond_to :tarif_list_filtr
        @controller.tarif_list_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter tarif_list_filtr records" do
        get :index, 'tarif_lists_filtr' => {'tarif_list_filtr_region_id' => 1109 }
        assert_response :success 
        assert_select('table[id=?]', 'tarif_list_table')

      end      
    end
    
    describe 'tarif_lists' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id*=?]', 'tarif_list_table')
        if TarifList.count > 0
          assert_select('tr[id*=?]', 'tarif_list_raw')
        end
      end
      
      it 'must filtr when filtr is changed' do
        get :index
        assert :success
        count_before = @controller.tarif_lists.model.count
        if count_before > 0
          last_raw = @controller.tarif_lists.model.last
          get :index, 'tarif_lists_filtr' => {'tarif_lists_filtr_regionr_id' => last_raw.tarif_list_id }
          assert :success
          count_after = @controller.tarif_lists.model.count
          count_after.must_be :>, count_before
        end
      end

      it 'must filtr when tarif_list_raw is changed' do
        get :index
        assert :success
        count_before = @controller.tarif_lists.model.count
        if count_before > 1
          next_raw_id = @controller.tarif_lists.model.last.id
          get :index, 'current_id' => {'service_category_group' => next_raw_id }
          assert :success
          count_after = @controller.tarif_lists.model.count
          count_after.must_be :>, count_before
        end
      end
    end
    
  end
      
end
