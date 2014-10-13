require 'test_helper'

describe Demo::HomeController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
#    sign_in @user
  end
  
  describe 'skip verifying authenticity token' do
    it 'must skip if user-agent in allowed_user_agents lists and url is root' do
      @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
      get :index, format: :js
      assert_response :success, [@controller.controller_name, @response.redirect_url, @response.message, flash[:alert], @controller.params]
    end

    it 'must skip if user-agent in allowed_user_agents lists and url is public' do
      @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
      get :demo_results, format: :js
#      raise(StandardError, @controller.send(:allow_skip_authenticate_user))
      assert_response :success, [@controller.controller_name, @response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
    end

    it 'should not skip if user-agent not in allowed_user_agents lists and url is public' do
      @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots) dddd"      
      assert_raise ActionController::InvalidCrossOriginRequest do
        get :demo_results, format: :js
      end
    end
  end
      
end

describe Home1Controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
#    sign_in @user
  end
  
  describe 'skip verifying authenticity token' do
    it 'should not skip if user-agent in allowed_user_agents lists and url is private' do
      @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
      get :index, format: :js  
      assert_response :unauthorized
    end

    it 'should not skip if user-agent not in allowed_user_agents lists and url is private' do
      @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots) dddd"
      get :index, format: :js  
      assert_response :unauthorized
    end
  end
      
end

describe UsersController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
#    sign_in @user
  end
  
  describe 'skip verifying authenticity token' do
    it 'should not skip if user-agent in allowed_user_agents lists and url is users' do
      @request.headers["HTTP_USER_AGENT"] = "Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)"
      get :index, format: :js
      assert_response :unauthorized
    end
  end
end
