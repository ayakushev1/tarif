require 'test_helper'

describe Service::CriteriaController do
  describe 'index action' do
    it 'must work' do
      get :index, :category_id => 0
      assert_response :success
      assert_select('div[id=?]', 'service_criteria_index')
      assert_select('table[id=?]', 'service_criteria_table')

      xhr :get, :index, :category_id => 0
      assert_response :success
      @response.body.html_safe.must_be :=~, /div id=\\\"service_criteria_index\\\"/
      @response.body.html_safe.must_be :=~, /table id=\\\"service_criteria_table\\\"/
    end
    
  end
      
end
