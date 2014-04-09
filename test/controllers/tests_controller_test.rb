require 'test_helper'

class TestsController < ApplicationController
  include Crudable
  crudable_actions :new, :index, :show, :foo
end

class Test < ActiveRecord::Base; end

module Sub
  module Admin 
    class Sub::Admin::FirstTableController < ApplicationController 
      include Crudable
      crudable_actions :all
    end
  end
end

describe TestsController do
  
  before do
#    Rails.application.routes.eval_block( Proc.new { resources :tests } )
    TestsController.crudable_actions :index, :show, :foo
  
    @valid_list = [:index, :show]
    @invalid_list = [:foo]
    @controller_action_list = TestsController.action_methods.collect!{|a| a.to_sym}.to_a
  end
  
  it 'must have actions from valid crudable_action list' do
    check = @valid_list.inject do |result, crudable_action|
      result && @controller_action_list.member?(crudable_action)
    end    
    assert check, @controller_action_list  
  end

  it 'must not have crudable actions not included in crudable_action list' do
    crudable_not_in_list = TestsController::CRUDABLE_ACTIONS - @valid_list
    check = crudable_not_in_list.inject do |result, crudable_action|
      result or @controller_action_list.member?(crudable_action)
    end || true   
    assert check, crudable_not_in_list  
  end
   
  it 'must have crudable actions only from CRUDABLE_ACTIONS' do
    not_in_crudable_list = :foo
    assert !@controller_action_list.member?(not_in_crudable_list), @controller_action_list
  end
  
  it 'must have define access method to model variable by model name' do
    model_name = "sub_admin_first_table"
    Sub::Admin::FirstTableController.new.methods.include?(model_name.to_sym).must_be :==, true, Sub::Admin::FirstTableController.new.methods
  end

  it 'must have define access method to model collection by controller name' do
    collection_name = TestsController.controller_name.to_sym
    TestsController.new.methods.include?(collection_name).must_be :==, true
  end

  it 'must have define access method to form model variable by form_model name' do
    form_model_name = :test_form
    @controller.methods.include?(form_model_name).must_be :==, true, @controller.methods
  end

  it 'must define access method to table_name from controller class name' do
    TestsController.new.methods.include?(:table_name).must_be :==, true
    Sub::Admin::FirstTableController.new.table_name.must_be :==, 'sub_admin_first_tables'
  end

  it 'must correctly define access methods taking into account name_spaces function from controller class name' do
#    Sub::Admin::FirstTableController.new.slash_name_space.must_be :==, 'sub/admin/'
  end


end

