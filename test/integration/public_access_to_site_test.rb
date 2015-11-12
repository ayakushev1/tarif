require 'test_helper'
# три параметра: public or private part of site, signed or unsigned user, is user admin
# также unsigned user имеет доступ User (new, create) и  к своим User (edit, update)
#http://localhost:3000/users/confirmation?confirmation_token=6w-YpegQmxvXDDjzuSWD

describe HomeController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = @controller.current_or_guest_user #User.find_or_create_by(:name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
#    @user.save!(:validate => false)
  end

  it 'unsigned user must have access to root' do
    get :index  
    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end
     
  it 'signed user must be granted access' do
    sign_in @user
    get :short_description  
    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]    
  end
     
end

describe Users::SessionsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = @controller.current_or_guest_user #User.find_or_create_by(:name => "Гость", :email => "guest@example.com", :confirmed_at => Time.zone.now)
#    @user.skip_confirmation!
#    @user.save!(:validate => false)
  end
  
  after do
    @user.delete
  end

  it 'unsigned user must be able to login' do
    get :new#, :id => 0  
    assert_response :success    #( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type])
  end

  it 'signed user must be able to logout' do
    sign_in @user
    get :destroy#, :id => 0  
    assert_redirected_to root_path    #( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type])
    @controller.current_user.must_be_nil
  end
end
     
describe UsersController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = @controller.current_or_guest_user #User.find_or_create_by(:name => "Гость", :email => "guest@example.com")
#    @user.save!(:validate => false)
  end

  it 'new action must not be allowed for unsigned user' do
    get :new
    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end

  it 'create action must not be allowed for unsigned user' do
    post :create
    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end

  it 'show action must not be allowed for unsigned user' do
    get :edit, :id => @user.id
    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end
end


describe Users::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = @controller.current_or_guest_user #User.find_or_create_by(:name => "Гость", :email => "guest@example.com")
#    @user.save!(:validate => false)
  end

  it 'new action must be allowed for unsigned user' do
    get :new
    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end

  it 'create action must be allowed for unsigned user' do
    post :create
    assert_response :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end

  it 'show action must not be allowed for unsigned user' do
    get :edit, :id => @user.id
    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
  end
end


describe Users::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.first_or_create(:id => 3) do |user|
      user.name ="Гость111"
      user.email = "guest@example.com"; user.confirmed_at = Time.zone.now
      user.password = 'ddddddddd'
      user.skip_confirmation!
      user.save!(:validate => false)
      user.confirm
    end
    @user.confirm
    @another_user = User.find_or_create_by(:id => 20, :name => "Another", :email => "another@example.com", :confirmed_at => Time.zone.now)
    @another_user.skip_confirmation!
    @another_user.save!(:validate => false)
  end
  
  after do
    @user.delete; @another_user.delete
  end

  it 'unsigned user must have access to new and create actions' do
    sign_out @controller.current_or_guest_user
#    sign_in @controller.current_or_guest_user
    get :new  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type, @controller.current_or_guest_user.id])
  end
     
  it 'unsigned user should not have access to edit and update actions' do
    sign_out @user
    get :edit, :id => 3  
    assert_redirected_to new_user_session_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
    post :update, :id => 3  
    assert_redirected_to new_user_session_path    , [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
    delete :destroy, :id => 3  
    assert_redirected_to new_user_session_path , [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]   
  end

  it 'signed user must have access to edit and update actions of his account' do
    sign_in @user
    get :edit, :id => @user.id  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type])
    post :update, :id => @user.id , :user => {:id => @user.id, :password => 'ddddddddd', :current_password => @user.password}  
    assert_response( :success, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type])
  end
     
  it 'signed user should not have access to edit and update actions of other user account' do
    sign_in @user
    get :edit, :id => 20  
    assert_redirected_to root_path,    [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]
    post :update, :id => 20  
    assert_redirected_to root_path , [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]   
    delete :destroy, :id => 20  
    assert_redirected_to root_path, [@response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params, @controller.user_type]    
  end
end
     

describe Customer::PaymentsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it 'must accept yandex post request' do
    @request.headers["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
    post :process_payment
    assert_response :success, [@request.headers, @response.redirect_url, @response.message, @controller.params, @controller.user_type]
  end


end

