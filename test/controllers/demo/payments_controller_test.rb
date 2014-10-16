require 'test_helper'

describe Demo::PaymentsController do
  before do
    @user = User.new(:id => 0, :name => "Гость", :email => "guest@example.com", :password => '111111', :password_confirmation => '111111', :confirmed_at => Time.zone.now)
    @user.skip_confirmation_notification!
    @user.save!(validate: false)
  end
  
  describe 'fill_payment_form' do      
    it 'must show payment_form with filled fields' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :fill_payment_form
        assert_select('form[id=?]', 'new_payment_instruction')
        assert_select("[id=payment_instruction_sum][value*='100']")
      end
    end
  end
  
  describe 'send_payment_form' do      
    it 'must send payment_form if form filled correctly' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        post :send_payment_form, :payment_instruction => {:sum => 100.0, :paymentType => 'AC'}
        @response.header['Location'].must_be :=~, /money.yandex.ru/
      end
    end
  
    it 'must render fill_payment_form if form filled not correctly' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        post :send_payment_form, :payment_instruction => {:sum => 99.0, :paymentType => 'AC1'}
        assert_select('form[id=?]', 'new_payment_instruction')
      end
    end
  
    it 'fill_payment_form must show alert' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        post :send_payment_form, :payment_instruction => {:sum => 99.0, :paymentType => 'AC1'}
        assert_select("div [class='alert alert-error alert-block']")
      end
    end
  
    it 'must add record to customer_transactions if form filled correctly' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do        
        assert_difference 'Customer::Transaction.count' do
          post :send_payment_form, :payment_instruction => {:sum => 100.0, :paymentType => 'AC'}
        end
      end
    end
  
    it 'request to yandex must include transaction_id in label param if form filled correctly' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do        
        post :send_payment_form, :payment_instruction => {:sum => 100.0, :paymentType => 'AC'}
        transaction_id = Customer::Transaction.order(:id).last.id 
        @response.header['Location'].must_be :=~, /label=#{transaction_id}/  
      end
    end
  
  end
  
  describe 'wait_for_payment_being_processed action' do
    it 'must have refresh button' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :wait_for_payment_being_processed
        assert_response :success
        assert_select("[href='/demo/payments/wait_for_payment_being_processed']")
      end
    end

    it 'must render wait_for_payment_being_processed if customer has no free trials' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do
        get :wait_for_payment_being_processed
        assert_response :success
        assert_select("[href='/demo/payments/wait_for_payment_being_processed']")
      end
    end
  
    it 'must redirect_to demo_optimization_steps_choose_load_calls_options_path if customer has free trials' do
      sign_in @user
      @controller.stub :customer_has_free_trials?, true do
        get :wait_for_payment_being_processed
        assert_redirected_to demo_optimization_steps_choose_load_calls_options_path
      end
    end
  end

  describe 'process_payment' do
    before  do
      sign_in @user
      @controller.stub :customer_has_free_trials?, false do        
        post :send_payment_form, :payment_instruction => {:sum => 100.0, :paymentType => 'AC'}
      end
      get :wait_for_payment_being_processed
#      assert_response :success, [@response.redirect_url, @response.message, @controller.alert, @controller.params, User.find(0)]
      @user_id = @controller.current_user.id
      transaction = Customer::Transaction.cash.last
      @transaction_id = transaction.id
      @transaction_user_id = transaction.user_id
      sign_out @user

      @request_params = {
        'notification_type' => 'card-incoming', #p2p-incoming
        'operation_id' => 111,
        'amount' => 100.0,
        'withdraw_amount' => 100.5,
        'currency' => 643,
        'datetime' => Time.now(),
        'sender' => '',
        'codepro' => '',
        'label' => "#{@transaction_id}",
        'sha1_hash' => 'sha1_hash',
        'test_notification' => nil,
      }      
    end
    
    it 'must return error if format is not yandex_payment_notification' do
      post :process_payment, {:format => :html}.merge(@request_params)
      assert_response 201#, [@response.redirect_url, @response.message, @controller.params]
    end
    
    it 'must accept yandex post request' do
      @request.headers["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
      assert_difference 'Customer::Transaction.count' do
        post :process_payment, {:format => :yandex_payment_notification}.merge(@request_params)
      end
      assert_response 200
     
    end

    it 'must increase free trials' do
      @request.headers["CONTENT_TYPE"] = "application/x-www-form-urlencoded"
      post :process_payment, {:format => :yandex_payment_notification}.merge(@request_params)
      @transaction_user_id.must_be :==, @user.id
      Customer::Info.services_used.where(:user_id => @transaction_user_id).first.info['tarif_optimization_count'].must_be :==, 1
    end
  
  end  
end
