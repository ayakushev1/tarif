require 'test_helper'

describe Price::StandardFormulasController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'price_standard_formulas_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"price_standard_formulas_index\\\"/
    end
    
    describe 'price_standard_formulas_index table' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'price_standard_formula_table')

        xhr :get, :index, :accept => 'text/html'
        @response.body.html_safe.must_be :=~, /table id=\\\"price_standard_formula_table\\\"/
      end
      
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'price_standard_formula_filtr') do |filtr|
          assert_select('select[id=?]', 'price_standard_formula_filtr_volume_id')
        end
      end

      it 'controller must have standard_formula_filtr method of Filtrable type' do
        @controller.must_respond_to :standard_formula_filtr
        @controller.standard_formula_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter standard_formula_filtr records" do
        get :index, 'price_standard_formula_filtr' => {'price_standard_formula_filtr_price_volume_id' => 1109 }
        assert_response :success 
        assert_select('table[id=?]', 'price_standard_formula_table')

      end      
    end
    
    describe 'standard_formulas' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id*=?]', 'price_standard_formula_table')
        if Price::Formula.count > 0
          assert_select('tr[current_id_name=price_standard_formula_id]')
        end
      end
      
      it 'must filtr when filtr is changed' do
        get :index
        assert :success
        count_before = @controller.standard_formulas.model.count
        if count_before > 0
          last_raw = @controller.standard_formulas.model.last
          get :index, 'price_standard_formula_filtr' => {'volume_id' => last_raw.volume_id }
          assert :success
          count_after = @controller.standard_formulas.model.count
          count_after.must_be :<, count_before
        end
      end

    end
    
  end
      
end
