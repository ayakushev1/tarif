class Customer::Payment < ActiveType::Object
  attribute :action, :string, default: "https://money.yandex.ru/quickpay/confirm.xml"
  attribute :receiver, :string, default:  "410011358898478"
  attribute :formcomment, :string, default: "Проект www.mytrifs.ru"
  attribute :short_dest, :string, default: "Проект www.mytrifs.ru, перевод средств"
  attribute :label, :string, default: ""
  attribute :quickpay_form, :string, default: "shop"
  attribute :targets, :string, default: "www.mytarifs.ru Перевод средств"
  attribute :sum, :float, default: 100.00
  attribute :paymentType, :string, default: "PC"
  attribute :successURL, :string, default: "www.mytarifs.ru/customer/payments/wait_for_payment_being_processed"
        
  validates_numericality_of :sum, greater_than_or_equal_to: 100.0
  validates_inclusion_of :paymentType, in: %w( AC PC )
  
#  after_validation -> {raise(StandardError)}
 
  def initialize(init_values = {})
    super
    label = init_values[:label]#if init_values[:label]
    sum = init_values[:sum] #if init_values[:sum]
    paymentType = init_values[:paymentType] #if init_values[:paymentType]
  end 

  def url_to_yandex(current_or_guest_user)
    transaction_id = current_or_guest_user.customer_transactions_cash.create(:status => {}, :description => {}, :made_at => Time.zone.now).id
    instruction_params = to_yandex_params(:label => transaction_id)
    current_or_guest_user.customer_transactions_cash.find(transaction_id).update(:description => instruction_params)
    "https://money.yandex.ru/quickpay/confirm.xml?#{instruction_params.to_param}" #ERB::Util.url_encode() 
  end
  
  def to_yandex_params(values = {})
    {
      :action => values[:action] || action,
      :receiver => values[:receiver] || receiver,
      :formcomment => values[:formcomment] || formcomment,
      :"short-dest" => values[:short_dest] || short_dest,
      :label => values[:label] || label,
      :"quickpay-form" => values[:quickpay_form] || quickpay_form,
      :targets => values[:targets] || targets,
      :sum => values[:sum] || sum,
      :paymentType => values[:paymentType] || paymentType,
      :successURL => values[:successURL] || successURL    
    }
  end

  def persisted?
    false
  end  
end

