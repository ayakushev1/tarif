require 'test_helper'

describe Price::FormulasController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'price_formulas_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"price_formulas_index\\\"/
    end
    
    describe 'price_formulas_index table' do
      it 'must exist' do
        get :index
        assert_select('table[id*=?]', 'price_formula_table')

        xhr :get, :index, :accept => 'text/html'
        @response.body.html_safe.must_be :=~, /table id=\\\"price_formula_table\\\"/
      end
      
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'price_formula_filtr') do |filtr|
          assert_select('select[id=?]', 'price_formula_filtr_standard_formula_id')
        end
      end
      
      it 'controller must have ormula_filtr method of Filtrable type' do
        @controller.must_respond_to :formula_filtr
        @controller.formula_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter formula_filtr records" do
        get :index, 'price_formula_filtr' => {'standard_formula_id' => 0 }
        assert_response :success 
        assert_select('table[id=?]', 'price_formula_table')

      end      
    end
    
    describe 'formulas' do
      it 'must exist' do
        get :index
        assert :success
        assert_select('table[id*=price_formula_table]')
        if Price::Formula.count > 0
          assert_select('tr[current_id_name=price_formula_id]')
        end
      end
      
      it 'must filtr when filtr is changed' do
        get :index
        assert :success
        count_before = @controller.formulas.model.count
        if count_before > 0
          last_raw = @controller.formulas.model.last
          get :index, 'price_formula_filtr' => {'standard_formula_id' => last_raw.standard_formula_id }
          assert :success
          count_after = @controller.formulas.model.count
          count_after.must_be :<, count_before
        end
      end
    end
    
  end
      
end
