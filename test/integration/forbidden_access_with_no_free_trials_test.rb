require 'test_helper'
#    ['optimization_steps', 'calls', 'history_parsers', 'tarif_optimizators'].include?(controller_name)

describe Demo::TarifOptimizatorController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
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

describe Demo::HistoryParserController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
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

describe Demo::CallsController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
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

class Demo::OptimizationStepsController < ApplicationController
  def set_free_trials(result); @result = result; end  
  def customer_has_free_trials?; @result;end
end


describe Demo::OptimizationStepsController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'choose_load_calls_options action if customer has no free_trials' do      
    it 'must redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :choose_load_calls_options
        assert_redirected_to root_path, @controller.customer_has_free_trials?
      end
    end

    it 'should not redirect to root_path' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, true do
        get :choose_load_calls_options
        assert_response :success, @controller.customer_has_free_trials? 
      end
    end
  
  end
  
end
