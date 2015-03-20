require 'test_helper'

describe Customer::ServicesController do
  before do
    @current_user_id = 2
    @current_user = User.find(@current_user_id) 
  end
  
  describe 'index action' do
    it 'must work' do
      get :index
      assert_response :success
      assert_select('div[id=customer_services_index]')

      xhr :get, :index
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"customer_services_index\\\"/
    end
    
    describe 'consolidated_customer_services_table' do
      it 'must exists' do
        get :index
        assert_response :success
        assert_select('table[id=consolidated_customer_services_table]')
  
        xhr :get, :index
        assert_response :success
        @response.body.html_safe.must_be :=~, /table id=\\'consolidated_customer_services_table\\'/
      end
    end
    
    describe 'customer_service_table' do
      it 'must exists' do
        get :index
        assert_response :success
        assert_select('table[id=customer_service_table]')
  
        xhr :get, :index
        assert_response :success
        @response.body.html_safe.must_be :=~, /table id=\\\"customer_service_table\\\"/
      end

      describe 'customer_calls_table' do
        it 'must exists' do
          get :index
          assert_response :success
          assert_select('table[id=customer_call_table]')
    
          xhr :get, :index
          assert_response :success
          @response.body.html_safe.must_be :=~, /table id=\\\"customer_call_table\\\"/
        end
        
      end
      
    end

    describe 'customer_stat_table' do
      it 'must exists' do
        get :index
        assert_response :success
        assert_select('table[id=customer_stat_table]')
  
        xhr :get, :index
        assert_response :success
        @response.body.html_safe.must_be :=~, /table id=\\\"customer_stat_table\\\"/
      end

      it 'must have start statistic calculations' do
        get :index
        assert_select('a[id=calculate_statistic]')
      end
      
      it 'check' do
        @fq_tarif_operator_id = 1025
        @fq_tarif_region_id = 1238
        get :index
        session[:current_user]["user_id"] = 2
        get :index, :current_id => {'customer_service_id' => 2, 'consolidated_customer_service_id' => 7000000000}
        tarif_class_id = @controller.customer_services.model.where(:id => session[:current_id]['customer_service_id']).last.tarif_class_id
        
        chosen_tarif_class_categories = tarif_class_category_ids = TarifOptimization::QueryConstructor.new(self, {:tarif_class_ids => [tarif_class_id]}).tarif_class_categories.collect{|tc| tc[0].to_i}.sort
        correct_tarif_class_categories = Service::CategoryTarifClass.where(:tarif_class_id => 0).order(:id).pluck(:id)
        (chosen_tarif_class_categories - correct_tarif_class_categories).must_be :==, [], correct_tarif_class_categories        
      end 
    end
    
  describe 'calculate statistic method' do
    it 'must exists' do
#      request.env['HTTP_REFERER'] = "/customer/services/#{@customer_service_id}"
      get :calculate_statistic
      assert_response :redirect
    end

    it 'must redirect back' do
      request.env['HTTP_REFERER'] = "/customer/services/#{@current_user_id}"
      get :index
      get :calculate_statistic
      assert_redirected_to :controller => 'customer/services', :action => 'index'
    end
    
  end
  end
    
end
