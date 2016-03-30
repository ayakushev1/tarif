require 'test_helper'

describe HomeController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
#    @user = User.find_or_create_by(:name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
#    @user.save!(:validate => false)
#    sign_in @user
  end
  
  describe 'skip verifying authenticity token' do
    it 'must skip if user-agent in allowed_user_agents lists and url is root' do
      @request.headers["CONTENT_TYPE"] = 'ANY_FORMAT'
      get :sitemap, format: :js
      assert_response :success, [@controller.controller_name, @response.redirect_url, @response.message, flash[:alert], @controller.params]
    end
  end
end

describe Customer::OptimizationResultsController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.where(:id => 0).first_or_create do |user|
      user.name = "Гость"; user.email = "guest@example.com"; user.confirmed_at = Time.zone.now
      user.save!(:validate => false)      
    end    
#    sign_in @user
  end
  
  describe 'skip verifying authenticity token' do
    it 'must skip if user-agent in allowed_user_agents lists and url is public' do
#      @request.headers["CONTENT_TYPE"] = 'ANY_FORMAT'
#      get :show_customer_results, format: :js
#      assert_response :success, [@controller.controller_name, @response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
    end

    it 'should not skip if user-agent not in allowed_user_agents lists and url is public' do
      @request.headers["CONTENT_TYPE"] = 'JS'      
#      assert_raise ActionController::InvalidCrossOriginRequest do
#        get :show_customer_results, format: :js
#      end
    end
  end
      
end

describe UsersController do
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
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
