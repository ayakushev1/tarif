require 'test_helper'
require 'minitest/mock'
#    ['optimization_steps', 'calls', 'history_parsers', 'tarif_optimizators'].include?(controller_name)

describe Customer::TarifOptimizatorsController do
  before do
    @user = User.new(:name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'index action if customer has no free_trials' do      
    it 'must redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :index
        assert_redirected_to root_path
      end
    end

    it 'should not redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, true do
        get :index
        assert_response :success
      end
    end
  
  end
  
end

describe Customer::HistoryParsersController do
  before do
    @user = User.new(:name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'prepare_for_upload action if customer has no free_trials' do      
    it 'must redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :prepare_for_upload
        assert_redirected_to root_path
      end
    end

    it 'should not redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, true do
        get :prepare_for_upload
        assert_response :success
      end
    end
  
  end
  
end

describe Customer::CallsController do
  before do
    @user = User.new(:name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'index action if customer has no free_trials' do      
    it 'must redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :index
        assert_redirected_to root_path
      end
    end

    it 'should not redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, true do
        get :index
        assert_response :success
      end
    end
  
  end
  
end


describe Customer::CallsController do
  before do
    @user = User.new(:name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'choose_load_calls_options action if customer has no free_trials' do      
    it 'must redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :generate_calls
        assert_redirected_to root_path, @controller.customer_has_free_trials?
      end
    end

    it 'should not redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, true do
        get :generate_calls
#        assert_response :success,  [@controller.customer_has_free_trials?, @response.redirect_url, @response.message, flash[:alert], @user.id, @controller.params]
      end
    end
  
  end
  
end
