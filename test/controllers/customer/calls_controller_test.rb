require 'test_helper'

describe Customer::CallsController do
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=customer_calls_index]')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"customer_calls_index\\\"/
    end    
    
    describe 'customer_calls table' do
      it 'must work' do
        get :index
        assert_select('table[id=customer_call_table]')
  
      end
    end

    describe 'filtr form' do
      it 'must work' do
        get :index
        assert_select('form[id=customer_calls_filtr]')
  
      end
      
      it 'must have filtr fields' do
        get :index
        assert_select('form[id=customer_calls_filtr]') do |form|
          assert_select 'select[id=customer_calls_filtr_base_service_id]'
          assert_select 'select[id=customer_calls_filtr_base_subservice_id]'
          assert_select 'select[id=customer_calls_filtr_user_id]'
          assert_select "select[id^=customer_calls_filtr_own_phone]" do
            assert_select 'select[id*=number]'
            assert_select 'select[id*=operator_id]'
            assert_select 'select[id*=region_id]'
          end
          assert_select "select[id^=customer_calls_filtr_partner_phone]" do
            assert_select 'select[id*=number]'
            assert_select 'select[id*=operator_id]'
            assert_select 'select[id*=region_id]'
          end
          assert_select "select[id^=customer_calls_filtr_connect]" do
            assert_select 'select[id*=operator_id]'
            assert_select 'select[id*=region_id]'
          end
        end
      end

      it 'must filtr customer_calls table' do
        
      end
    end
  end
  
  describe 'set_calls_generation_params action' do
    it 'must work' do
      get :set_calls_generation_params
      assert_response :success
      assert_select('div[id=customer_calls_set_calls_generation_params]')

      xhr :get, :set_calls_generation_params
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"customer_calls_set_calls_generation_params\\\"/
    end
    
    describe 'customer_calls_generation_params form' do
      it 'must work' do
        get :set_calls_generation_params
        assert_select('form[id=customer_calls_generation_params_own_region_filtr]')
      end   
      
      it 'must set session from params' do
        get :set_calls_generation_params, :customer_calls_generation_params_own_region_filtr => {:country_id => 1100}
        session[:filtr]['customer_calls_generation_params_own_region_filtr']['country_id'].must_be :==, '1100', session[:filtr]
      end
      
      it 'must take default value for select fields from session' do
        get :set_calls_generation_params, :customer_calls_generation_params_own_region_filtr => {:country_id => 1100}
        css_select('select[id*=country_id] option[selected]').first.attributes['value'].must_be :==, '1100'
      end 
    end    
  end
  
  describe 'set_default_calls_generation_params action' do
    it 'must work' do
      get :index
      get :set_default_calls_generation_params
      assert_response :redirect
      assert_redirected_to customer_calls_set_calls_generation_params_path
      
      xhr :get, :set_default_calls_generation_params
      assert_response :redirect
      assert_redirected_to customer_calls_set_calls_generation_params_path
    end

    it 'must take default value for select fields from session' do
      get :set_calls_generation_params, :customer_calls_generation_params_own_region_filtr => {:country_id => 1500}
      get :set_default_calls_generation_params
      get :set_calls_generation_params
      css_select('select[id*=country_id] option[selected]').first.attributes['value'].must_be :==, '1100'
    end 
  end
  
  describe 'generate_calls action' do
    it 'must work' do
      @controller.must_respond_to :generate_calls
    end
  end
      
end
