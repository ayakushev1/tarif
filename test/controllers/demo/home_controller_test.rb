require 'test_helper'

describe Demo::HomeController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'index action' do
    it 'must work for html request' do
      get :index
      assert_response :success
      assert_select('div[id=?]', 'demo_home_index')
    end
    
    it 'must work for ajax request' do
      xhr :get, :index, format: :js
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"demo_home_index\\\"/
    end

    it 'must work for get request with js' do
      get :index, format: :js
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"demo_home_index\\\"/
    end
  end
              
  describe 'customer_has_free_trials?' do      
    it 'method_name' do
      post :create, :user => {:email => @user.email, :password => @user.password}#, :confirmation_token => @user.confirmation_token
      assert_response :found, [@response.redirect_url, @response.message, @controller.alert, @controller.params, User.find(0)]
    end
  
  end
  
end
