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
        get :index, 'tarif_list_filtr' => {'region_id' => 1109 }
        assert_response :success 
        assert_select('table[id=?]', 'tarif_list_table')

      end      
    end
    
    describe 'tarif_lists' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id=tarif_list_table]')
        if TarifList.count > 0
          assert_select('tr[current_id_name=tarif_list_id]')
        end
      end
      
      it 'must filtr when filtr is changed' do
        get :index
        assert :success
        count_before = @controller.tarif_lists.model.count
        if count_before > 0
          last_raw = @controller.tarif_lists.model.last
          get :index, 'tarif_list_filtr' => {'region_id' => last_raw.region_id }
          assert :success
          count_after = @controller.tarif_lists.model.count
          count_after.must_be :<, count_before
        end
      end

      it 'must filtr when tarif_list_raw is changed' do
        get :index, :current_id => {'tarif_list_id' => 109}
        price_list_id_before = @controller.price_lists_for_index.model.first.id

        get :index, :current_id => {'tarif_list_id' => 133}        
        price_list_id_after = @controller.price_lists_for_index.model.first.id
        
        price_list_id_before.must_be :!=, price_list_id_after
      end
    end
    
    describe 'price_lists_for_index' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id=price_list_table]')
        if @controller.price_lists_for_index.model.count > 0
          assert_select('tr[current_id_name=price_list_id]')
        end
      end
            
    end
    
  end
  
  describe 'show action' do
    it 'must be' do
      get :show, :id => 109
      assert_response :success
      assert_select('div[id=?]', 'tarif_lists_show')

      xhr :get, :show, :id => 109
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"tarif_lists_show\\\"/
    end
  end

    describe 'price_lists_for_show' do
      it 'must exist' do
        get :show, :id => 109
        assert :success
        assert_select('table[id=price_list_table]')
        if @controller.price_lists_for_show.model.count > 0
          assert_select('tr[current_id_name=price_list_id]')
        end
      end
    end

    describe 'price_list filtr on show page' do
      it 'must exist' do
        get :show, :id => 109
        assert_select('form[id=price_list_filtr]') do |filtr|
          assert_select('select[id=price_list_filtr_service_category_group_id]')
          assert_select('select[id=price_list_filtr_is_active]')
          assert_select('select[id=price_list_filtr_price_list_to_show]')
        end
      end
      
      it 'controller must have tarif_list_filtr method of Filtrable type' do
        @controller.must_respond_to :price_list_filtr
        @controller.price_list_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter price_list records" do
        first = PriceList.where('service_category_tarif_class_id > 0').first
        if first
          get :show, :id => 109, 'price_list_filtr' => {'service_category_tarif_class_id' => first.service_category_tarif_class_id }
          assert_response :success 
          assert_select('table[id=price_list_table]')
        else
          get :show, :id => 109, 'price_list_filtr' => {'service_category_tarif_class_id' => nil }
          assert_response :success 
          assert_select('table[id=price_list_table]')
        end
      end      

      it "must filter price_list records with price_list_to_show filtr" do
        tarif_list_id = 109
        before = PriceList.where(:tarif_list_id => tarif_list_id).count

        get :show, :id => tarif_list_id, 'price_list_filtr' => {'price_list_to_show' => 'direct_tarif_price_lists' }
        assert_response :success 
        direct_tarif_price_lists = @controller.price_lists_for_show.model.count

        get :show, :id => tarif_list_id, 'price_list_filtr' => {'price_list_to_show' => 'tarif_class_price_lists' }
        assert_response :success 
        tarif_class_price_lists = @controller.price_lists_for_show.model.count
        
        direct_tarif_price_lists.must_be :!=, tarif_class_price_lists

      end      
    end

    describe 'formulas_for_show' do
      it 'must exist' do
        get :show, :id => 109
        assert :success
        assert_select('table[id=price_formula_table]')
        if @controller.price_formulas.model.count > 0
          assert_select('tr[current_id_name=price_formula_id]')
        end
      end
    end

    
      
end
