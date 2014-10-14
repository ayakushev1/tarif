require 'test_helper'

describe Demo::HomeController do
  before do
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
    sign_in @user
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
    
    describe 'customer_has_free_trials?' do
      
    end
  end
          
end
