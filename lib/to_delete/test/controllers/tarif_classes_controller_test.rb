require 'test_helper'

describe TarifClassesController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'tarif_classes_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"tarif_classes_index\\\"/
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'tarif_class_filtr') do |filtr|
          assert_select('select[id=?]', 'tarif_class_filtr_operator_id')
          assert_select('select[id=?]', 'tarif_class_filtr_privacy_id')
          assert_select('select[id=?]', 'tarif_class_filtr_standard_service_id')
        end
      end
      
      it 'controller must have tarif_class_filtr method of Filtrable type' do
        @controller.must_respond_to :tarif_class_filtr
        @controller.tarif_class_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter tarif classes records" do
        get :index, 'tarif_class_filtr' => {'operator_id' => Category::Operator::Const::Beeline }
        assert_response :success 
        @controller.tarif_classes.model.count.must_be :==, 40

        xhr :get, :index, 'tarif_class_filtr' => {'privacy_id' => _person }
        assert_response :success 
        @controller.tarif_classes.model.count.must_be :==, 31

        xhr :get, :index, 'tarif_class_filtr' => {'privacy_id' => _person, 'standard_service_id' => _tarif }
        assert_response :success 
        @controller.tarif_classes.model.count.must_be :==, 13
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
    it 'must work' do
      get :show, :id => 1
      assert_response :success
      assert_select('div[id=?]', 'tarif_classes_show')

      xhr :get, :show, :id => 1
      assert_response :success      
      @response.body.html_safe.must_be :=~, /div id=\\\"tarif_classes_show\\\"/
    end

    describe 'price_lists_for_show' do
      it 'must exist' do
        get :show, :id => 77
        assert :success
        assert_select('table[id=price_list_table]')
        if @controller.price_lists_for_show.model.count > 0
          assert_select('tr[current_id_name=price_list_id]')
        end
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

  describe 'new action' do
    it 'must work' do
      get :new
      assert_response :success
      assert_select('div[id=?]', 'tarif_classes_new')

      xhr :get, :new, :id => 1, 'tarif_class_form' => {:name => "MTC" }
      assert_response :success      
      @response.body.html_safe.must_be :=~, /div id=\\\"tarif_classes_new\\\"/
    end
  end
    
  describe 'edit action' do
    it 'must work' do
      get :edit, :id => 1, 'tarif_class_form' => {:name => "MTC" }
      assert_response :success
      assert_select('div[id=?]', 'tarif_classes_edit')

      xhr :get, :edit, :id => 1, 'tarif_class_form' => {:name => "MTC" }
      assert_response :success      
      @response.body.html_safe.must_be :=~, /div id=\\\"tarif_classes_edit\\\"/
    end
  end
    
  describe 'update action' do
    it 'must work' do
      put :update, :id => 1, 'tarif_class_form' => {:name => "MTC_1" }
      assert_response :redirect
      TarifClass.find(1).name.must_be :==, 'MTC_1'

      xhr :put, :update, :id => 1, 'tarif_class_form' => {:name => "MTC" }
      assert_response :redirect
      TarifClass.find(1).name.must_be :==, 'MTC'
    end
  end
end
