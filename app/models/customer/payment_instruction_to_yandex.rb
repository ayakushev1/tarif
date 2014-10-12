class Customer::PaymentInstructionToYandex 
  include ActiveModel::Model
  attr_accessor  :action, :receiver, :formcomment, :short_dest, :label, :quickpay_form, :targets, :sum, :paymentType, :successURL
  validates_numericality_of :sum, greater_than_or_equal_to: 100.0
  validates_inclusion_of :paymentType, in: %w( AC PC )

  
  def initialize
    super
    @action = "https://money.yandex.ru/quickpay/confirm.xml"
    @receiver = "410011358898478"
    @formcomment = "Проект www.mytrifs.ru, перевод средств"
    @short_dest = " Проект www.mytrifs.ru, перевод средств"
    @label = "$order_id"
    @quickpay_form = "shop"
    @targets = "www.mytarifs.ru Перевод средств"
    @sum = 100.00
    @paymentType = "PC"
    @successURL = "www.mytarifs.ru/demo/payments/wait_for_payment_being_processed"    
  end 

  def persisted?
    false
  end  
end

