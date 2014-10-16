class Demo::PaymentInstructionToYandex 
  include ActiveModel::Model
  attr_accessor  :action, :receiver, :formcomment, :short_dest, :label, :quickpay_form, :targets, :sum, :paymentType, :successURL
  validates_numericality_of :sum, greater_than_or_equal_to: 100.0
  validates_inclusion_of :paymentType, in: %w( AC PC )

  
  def initialize(init_values = {})
    super
    @action = "https://money.yandex.ru/quickpay/confirm.xml"
    @receiver = "410011358898478"
    @formcomment = init_values[:formcomment] || "Проект www.mytrifs.ru"
    @short_dest = init_values[:short_dest] || " Проект www.mytrifs.ru, перевод средств"
    @label = init_values[:label] || ""
    @quickpay_form = "shop"
    @targets = init_values[:targets] || "www.mytarifs.ru Перевод средств"
    @sum = init_values[:sum] || 100.00
    @paymentType = init_values[:paymentType] || "PC"
    @successURL = init_values[:successURL] || "www.mytarifs.ru/demo/payments/wait_for_payment_being_processed"    
  end 

  def to_yandex_params(values = nil)
    {
      :action => values[:action] || @action,
      :receiver => values[:receiver] || @receiver,
      :formcomment => values[:formcomment] || @formcomment,
      :"short-dest" => values[:short_dest] || @short_dest,
      :label => values[:label] || @label,
      :"quickpay-form" => values[:quickpay_form] || @quickpay_form,
      :targets => values[:targets] || @targets,
      :sum => values[:sum] || @sum,
      :paymentType => values[:paymentType] || @paymentType,
      :successURL => values[:successURL] || @successURL    
    }
  end

  def persisted?
    false
  end  
end

