require 'test_helper'

describe Customer::TarifOptimizatorsController do
  describe 'tarif_results action' do
    it 'must work' do
      get :recalculate
      get :index
      assert_response :success
#      tarifs = @controller.stat.tarif_results[session[:current_id]['service_sets_id']]
#      arr = tarifs.keys.collect {|key| tarifs[key] }
#      arr.must_be :==, true
    end
  end
  
  describe 'recalculate action' do
    it 'must work' do
#      get :recalculate
#      assert_response :redirect
    end
  end
    
end
