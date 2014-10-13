require 'test_helper'
# три параметра: public or private part of site, signed or unsigned user, is user admin
# также unsigned user имеет доступ User (new, create) и  к своим User (edit, update)


describe Demo::HomeController do
  before do
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
  end

  it 'unsigned user must have access to root' do
    get :index  
    assert_response :success    
  end
     
  it 'unsigned user should be redirected to root' do
    get :full_demo_results  
    assert_redirected_to new_user_session_path    
  end
     
  it 'signed user must be granted access' do
    sign_in @user
    get :full_demo_results  
    assert_response :success    
  end
     
end

describe Home1Controller do
  before do
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.save!(:validate => false)
#    sign_in @user
  end
  
  it 'unsigned user should be redirected to root' do
    get :index  
    assert_redirected_to new_user_session_path    
  end
     
  it 'signed user should be redirected to root' do
    sign_in @user
    get :index  
    assert_redirected_to root_path    
  end
     
  it 'signed admin must be granted access' do
    @admin = User.find_or_create_by(:id => 1, :name => ENV["TARIF_ADMIN_USERNAME"], :email => ENV["TARIF_ADMIN_USERNAME"], :confirmed_at => Time.zone.now)
    @admin.save!(:validate => false)
    sign_in @admin
    get :index  
    assert_response :success    
  end
     
end

describe Devise::SessionsController do
  before do
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.skip_confirmation!
    @user.save!(:validate => false)
  end
  
  after do
    @user.delete
  end

  it 'unsigned user must be able to login' do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :new#, :id => 0  
    assert_response :success    #( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
  end

  it 'signed user must be able to logout' do
    sign_in @user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    get :destroy#, :id => 0  
    assert_redirected_to root_path    #( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
    @controller.current_user.must_be_nil
  end
end
     
describe UsersController do
  before do
    @user = User.find_or_create_by(:id => 0, :name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
    @user.skip_confirmation!
    @user.save!(:validate => false)
    @another_user = User.find_or_create_by(:id => 2, :name => "Another", :email => "another@example.com", :confirmed_at => Time.zone.now)
    @another_user.skip_confirmation!
    @another_user.save!(:validate => false)
  end
  
  after do
    @user.delete; @another_user.delete
  end

  it 'unsigned user must have access to new and create actions' do
    get :new  
#    raise(StandardError, @controller.send(:allow_skip_authenticate_user))
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
  end
     
  it 'unsigned user should not have access to edit and update actions' do
    get :show, :id => 0  
    assert_redirected_to new_user_session_path    
    get :edit, :id => 0  
    assert_redirected_to new_user_session_path
    post :update, :id => 0  
    assert_redirected_to new_user_session_path    
    delete :destroy, :id => 0  
    assert_redirected_to new_user_session_path    
  end

  it 'signed user must have access to edit and update actions of his account' do
    sign_in @user
    get :show, :id => 0  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
    get :edit, :id => 0  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
    post :update, :id => 0  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params])
  end
     
  it 'signed user should not have access to edit and update actions of other user account' do
    sign_in @user
    get :show, :id => 2  
    assert_redirected_to root_path    
    get :edit, :id => 2  
    assert_redirected_to root_path    
    post :update, :id => 2  
    assert_redirected_to root_path    
    delete :destroy, :id => 2  
    assert_redirected_to root_path    
  end
end