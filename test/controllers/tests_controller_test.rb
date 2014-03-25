require 'test_helper'

class TestsController < ApplicationController
  include Crudable
  crudable_actions :new, :index, :show, :foo
  
end

class Test < ActiveRecord::Base
  
end

describe TestsController do
  
  before do
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
    model_name = TestsController.controller_name.singularize.to_sym
    assert @controller_action_list.member?(model_name), @controller_action_list << model_name
  end

  it 'must have define access method to model collection by controller name' do
    collection_name = TestsController.controller_name.to_sym
    assert @controller_action_list.member?(collection_name), @controller_action_list << collection_name
  end

end

