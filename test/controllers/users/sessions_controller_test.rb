require 'test_helper'

describe Users::SessionsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @save_result = @user.save!(validate: false)
  end
  
  after do
    @user.delete
  end
  
  describe 'after_action callback check_user_info' do
    it 'must init user_info if it is empty' do
      customer_infos_services_used_count_before = @user.customer_infos_services_used.count
      customer_transactions_services_used_count_before = @user.customer_transactions_services_used.count

      post :create, :user => {:email => @user.email, :password => @user.password}#, :confirmation_token => @user.confirmation_token
      assert_response :found, [@response.redirect_url, @response.message, @controller.alert, @controller.params, User.find(0)]

      customer_infos_services_used_count_after = @user.customer_infos_services_used.count
      customer_transactions_services_used_count_after = @user.customer_transactions_services_used.count

      customer_infos_services_used_count_after.must_be :==, 1
      if customer_infos_services_used_count_after > customer_infos_services_used_count_before
        (customer_transactions_services_used_count_after - customer_transactions_services_used_count_before).must_be :==, 1
      else
        (customer_transactions_services_used_count_after - customer_transactions_services_used_count_before).must_be :==, 0
      end      
    end
  end

end