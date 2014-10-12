require 'test_helper'

describe Demo::HomeController do
  before do
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
    sign_in @user

    @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
  end
  
  describe 'demo_results action' do
    it 'must skip if user-agent in allowed_user_agents lists' do
      get :demo_results, format: :js
      assert_response :success
    end
  end
      
end
