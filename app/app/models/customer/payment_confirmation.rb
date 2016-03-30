require "digest"
class Customer::PaymentConfirmation  < ActiveType::Object

  attribute :notification_type, :string
  attribute :operation_id, :string
  attribute :amount, :string
#  attribute :amount, :string
  attribute :withdraw_amount, :string
  attribute :currency, :string
  attribute :datetime, :string
  attribute :sender, :string
  attribute :codepro, :string
  attribute :label, :string
  attribute :sha1_hash, :string
  attribute :test_notification, :string

  validates_presence_of [:notification_type, :operation_id, :amount, :currency, :label, :sha1_hash]
#  validates_numericality_of :amount
#  validates_numericality_of :label, :only_integer => true
  validates_inclusion_of :notification_type, in: %w( card-incoming p2p-incoming )
  validates_inclusion_of :codepro, :in => [false, 'false', '']

  
  def initialize(init_values_1 = {})
    init_values = init_values_1.symbolize_keys.extract!(:notification_type, :operation_id, :amount, :withdraw_amount, :currency, :datetime, :sender, :codepro, :label, :sha1_hash, :test_notification)
    super init_values
    notification_type = init_values[:notification_type]
    operation_id = init_values[:operation_id]
    amount = init_values[:amount]# || 0).to_f
    withdraw_amount = init_values[:withdraw_amount]
    currency = init_values[:currency]
    datetime = init_values[:datetime]
    sender = init_values[:sender]
    codepro = init_values[:codepro]
    label = init_values[:label]
    sha1_hash = init_values[:sha1_hash]
    test_notification = init_values[:test_notification]
  end 
  
  def process_payment
    if valid? and check_hash
      update_customer_info(current_or_guest_user)
      UserMailer.payment_confirmation(current_or_guest_user, self).deliver
    else
      UserMailer.send_mail_to_admin_that_something_wrong_with_confirmation(self).deliver
    end
  end
  
  def update_customer_info(current_or_guest_user)
    User.transaction do
      Customer::Info::ServicesUsed.update_free_trials_by_cash_amount(current_or_guest_user.id, (self.amount.to_f / 0.98) )
#      Customer::Info::ServiceChoices.update_info(current_or_guest_user.id, Customer::Info::ServiceChoices.default_values_for_paid)
    end
  end
  
  def current_or_guest_user
    return @current_or_guest_user if @current_or_guest_user
    
    transaction_id = self.label
    user_id = Customer::Transaction.where(:id => transaction_id).first.user_id if Customer::Transaction.where(:id => transaction_id).exists?
    @current_or_guest_user = User.where(:id => user_id).first
  end
  
  def check_hash
    hash_hexdigest(hash_string) == sha1_hash ? true : false    
  end
  
  def hash_hexdigest(hash_string)
    Digest::SHA1.hexdigest(hash_string)
  end

  def hash_string
    [notification_type, operation_id, amount, currency, datetime, sender, codepro, ENV['YANDEX_MY_TARIF_SECRET'], label].collect do |item|
      item.to_s.dup.force_encoding("UTF-8")
    end.join('&')    
#    "#{notification_type}&#{operation_id}&#{amount}&#{currency}&#{datetime}&#{sender}&#{codepro}&#{ENV['YANDEX_MY_TARIF_SECRET']}&#{label}"
  end

  def persisted?
    false
  end  
end
