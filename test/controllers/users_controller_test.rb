require 'test_helper'

describe UsersController do
  it 'access method to model must return object of class of ActiveRecord' do
    get :show, {:id => 1}
    @controller.user.must_equal User.find(1)
  end  

  it 'access method to model collection must return collection of class of ActiveRecord' do
    get :index
    @controller.users.must_be_kind_of User.paginate(page: 1, :per_page => 10).class
  end  

  it 'create method must redirect to users/show' do
    assert_difference 'User.count' do
      post(:create, user: {:name => 'test 2', :password => '111', :password_confirmation => '111'})
    end
    assert_redirected_to user_path(assigns(:model)), assigns(:model)
  end  
end
