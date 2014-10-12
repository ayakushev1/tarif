class Customer::PaymentsController < ApplicationController

  before_action :check_if_instructions_to_yandex_are_in_session, only: [:fill_payment_form]
  
  def instructions_to_yandex
    Filtrable.new(self, "instructions_to_yandex")
  end

  
  def check_if_instructions_to_yandex_are_in_session  
    accounting_period = accounting_periods.blank? ? -1 : accounting_periods[0]['accounting_period']  
    if !session[:filtr] or session[:filtr]['instructions_to_yandex_filtr'].blank?
      session[:filtr] ||= {}; session[:filtr]['instructions_to_yandex_filtr'] ||= {}
      session[:filtr]['instructions_to_yandex_filtr']  = 
        {
          :action => "https://money.yandex.ru/quickpay/confirm.xml",
          :receiver => "410011358898478",
          :formcomment => "Проект www.mytrifs.ru, перевод средств",
          :short_dest => " Проект www.mytrifs.ru, перевод средств",
          :label => "$order_id",
          :quickpay_form => "shop",
          :targets => "www.mytarifs.ru Перевод средств",
          :sum => 100.00,
          :paymentType => "PC",
          :successURL => "www.mytarifs.ru/demo/payments/wait_for_payment_being_processed"
        }        
    end
  end
end

