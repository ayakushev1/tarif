require 'test_helper'

describe ParametersController do
  before do
    Customer::Call.create(:base_subservice_id => 50, :own_phone => {"number" => "7000000000", "operator_id" => "1025", "region_id" =>"1501"})      
  end
  
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'parameters_index')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"parameters_index\\\"/
    end
    
    describe 'filtr on index page' do
      it 'must exist' do
        get :index
        assert_select('form[id=?]', 'parameters_filtr') do |filtr|
          assert_select('select[id=?]', 'parameters_filtr_source_type_id')
          assert_select('select[id=?]', 'parameters_filtr_source[field_type_id]')
        end
      end
      
      it 'controller must have params method of Filtrable type' do
        @controller.must_respond_to :parameter_filtr
        @controller.parameter_filtr.must_be_kind_of(Filtrable)
      end
      
      it "must filter parameters records" do
        get :index, 'parameters_filtr' => {'parameter_source_type_id' => 130 }
        assert_response :success 
        @controller.parameters.model.count.must_be :>, 0

      end      
    end
    
    describe 'individual parameter description on index page' do
      it 'must exist' do
        get :index
        assert_select('div[id=?]', 'parameter_form_show')
      end
    end
  end
      
end
