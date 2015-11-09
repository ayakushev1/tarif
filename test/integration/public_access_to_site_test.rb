require 'test_helper'
# три параметра: public or private part of site, signed or unsigned user, is user admin
# также unsigned user имеет доступ User (new, create) и  к своим User (edit, update)
#http://localhost:3000/users/confirmation?confirmation_token=6w-YpegQmxvXDDjzuSWD

describe Devise::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:name => "Гость", :email => "guest@example.com")
    @user.save!(:validate => false)
  end

  it 'new action must be allowed for unsigned user' do
    get :new
    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
  end

  it 'create action must be allowed for unsigned user' do
    post :create
    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
  end

  it 'show action must be allowed for unsigned user' do
    get :edit, :id => 0
#    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
  end
end


describe HomeController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
  end

  it 'unsigned user must have access to root' do
    get :index  
    assert_response :success    
  end
     
  it 'unsigned user should be redirected to root' do
#    get :full_demo_results  
#    assert_redirected_to new_user_session_path    
  end
     
  it 'signed user must be granted access' do
    sign_in @user
#    get :full_demo_results  
#    assert_response :success    
  end
     
end

describe Users::SessionsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.find_or_create_by(:name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.skip_confirmation!
    @user.save!(:validate => false)
  end
  
  after do
    @user.delete
  end

  it 'unsigned user must be able to login' do
    get :new#, :id => 0  
    assert_response :success    #( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
  end

  it 'signed user must be able to logout' do
    sign_in @user
    get :destroy#, :id => 0  
    assert_redirected_to root_path    #( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
    @controller.current_user.must_be_nil
  end
end
     
describe Devise::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.first_or_create(:id => 3, :name => "Гость111") do |user|
      user.email = "guest@example.com"; user.confirmed_at = Time.zone.now
      user.password = 'ddddddddd'
      user.skip_confirmation!
      user.save!(:validate => false)
      user.confirm
    end
    @user.confirm
    @another_user = User.find_or_create_by(:id => 2, :name => "Another", :email => "another@example.com", :confirmed_at => Time.zone.now)
    @another_user.skip_confirmation!
    @another_user.save!(:validate => false)
  end
  
  after do
    @user.delete; @another_user.delete
  end

  it 'unsigned user must have access to new and create actions' do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :new  
#    raise(StandardError, @controller.send(:allow_skip_authenticate_user))
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
  end
     
  it 'unsigned user should not have access to edit and update actions' do
    sign_out @user
#    get :show
#    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
    get :edit, :id => 3  
    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
    post :update, :id => 3  
    assert_redirected_to new_user_session_path    , [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
    delete :destroy, :id => 3  
    assert_redirected_to new_user_session_path , [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]   
  end

  it 'signed user must have access to edit and update actions of his account' do
    sign_in @user
#    get :show, :id => 0  
#    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
    get :edit, :id => 3  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
    post :update, :id => 3 , :user => {:id => 3, :password => 'ddddddddd', :current_password => @user.password}  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
  end
     
  it 'signed user should not have access to edit and update actions of other user account' do
    sign_in @user
#    get :show, :id => 2  
#    assert_redirected_to root_path    
    get :edit, :id => 2  
#    assert_redirected_to root_path,    [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
    post :update, :id => 2  
#    assert_redirected_to root_path , [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]   
    delete :destroy, :id => 2  
#    assert_redirected_to root_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]    
  end
end
     

describe Customer::PaymentsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it 'must accept yandex post request' do
    @request.headers["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
    post :process_payment
    assert_response :success, [@request.headers, @response.redirect_url, @response.message, @controller.params]
  end


end

