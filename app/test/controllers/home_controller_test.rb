require 'test_helper'

describe HomeController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'index action' do
    it 'must work for html request' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'home_index')
    end
    
    it 'must work for ajax request' do
      xhr :get, :index, format: :js
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"home_index\\\"/
    end
  end
              
  describe 'method customer_has_free_trials?' do      
    it 'must show calls_generation_params button if there are free trails' do
      sign_in @user
      get :index
      Customer::Info::ServicesUsed.where(:user_id =>@user.id).count.must_be :==, 1
      assert_select('[href*=choose_load_calls_options]') #, @response.body # href="/customer/calls/set_calls_generation_params"
    end
  
    it 'must show payment button if no free trails' do
      sign_in @user
      Customer::Info::ServicesUsed.where(:user_id =>@user.id).first_or_create.update(:info => {:calls_modelling_count => 0})
      get :index
      assert_select("[href*='customer/payments/new']") 
    end
  
  end
  
end
