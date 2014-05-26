require 'test_helper'

describe UsersController do
  
  before do
    @c = @controller
  end

  describe 'before action methods' do
    describe 'model_params method' do
      it 'must returm {} if params[#form_model_name] is nil' do
        xhr :get, :new, @c.form_model_name => {}
        @c.model_params.must_be_kind_of(Hash)
      end
      
      it 'must return params[#form_model_name]' do
        xhr :get, :new, @c.form_model_name => {'name' => 'value'}
        @c.model_params['name'].must_be :==, 'value'
      end
    end
    
    describe 'set_model method' do
      it 'must init @model instance variable if params[:id] is not nil' do
        xhr :get, :new, 'user_form' => {'id'=>111, "name"=>'user_11111'}
        @c.instance_variable_get(:@model)['id'].must_be :==, 111
      end

      it 'must init @model from session[:form] if #form_model_name is kind_of Formable' do
        session[:form] = {}
        session[:form]['user_form'] = {'id'=>111, "name"=>'user_111'} 
        xhr :get, :new
        @c.instance_variable_get(:@model)['name'].must_be :==, 'user_111'
      end
      
    end
    
    describe 'Formable when defined in form_model_name' do
      it 'must init session[:form][#form_model_name] from params[#form_model_name]' do
        xhr :get, :new, 'user_form' => {'id'=>1111, "name"=>'user_11111'}
        session[:form]['user_form']['name'].must_be :==, 'user_11111'
        xhr :get, :new, 'user_form' => {'id'=>2222, "name"=>'user_2222'}
        session[:form]['user_form']['name'].must_be :==, 'user_2222'
      end
      
      describe 'model method' do
        it 'must return instance of model supplied during init' do
          xhr :get, :new, 'user_form' => {'id'=>11111, "name"=>'user_11111'}
          @c.user_form.model['id'].must_be :==, 11111
        end
      end
    end
    
  end
  
  describe 'index action' do
    it 'must have collection access method' do
      xhr :get, :index
      @c.must_respond_to :users
    end
  end

  describe 'edit action' do
    it 'must preserve field value after edit' do
      xhr :get, :edit, :id=> 2, 'user_form' => {'name' => 'user_2222'}
      @c.session[:form]['user_form']['name'].must_be :==, 'user_2222'            
    end
  end
  
  describe 'update action' do
    it 'must update model' do
      xhr :put, :update, 'id' => 2, 'user_form' => {"name" => 'new_name'}
      @c.user['name'].must_be :==, 'new_name'      
    end
  end

  describe 'delete action' do
    it 'must delete model' do
      assert_difference 'User.count', -1 do
        delete :destroy, 'id' => 2
      end      
    end
  end
end

