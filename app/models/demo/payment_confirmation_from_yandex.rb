require "digest"
class Demo::PaymentConfirmationFromYandex 
  include ActiveModel::Model
  attr_accessor  :notification_type, :operation_id, :amount, :withdraw_amount, :currency, :datetime, :sender, :codepro, :label, :sha1_hash, :test_notification
  validates_presence_of [:notification_type, :operation_id, :amount, :currency, :label, :sha1_hash]
  validates_numericality_of :amount
  validates_numericality_of :label, :only_integer => true
  validates_inclusion_of :notification_type, in: %w( card-incoming p2p-incoming )

  
  def initialize(init_values_1 = {})
    init_values = init_values_1.symbolize_keys.extract!(:notification_type, :operation_id, :amount, :withdraw_amount, :currency, :datetime, :sender, :codepro, :label, :sha1_hash, :test_notification)
    super init_values
    @notification_type = init_values[:notification_type]
    @operation_id = init_values[:operation_id]
    @amount = (init_values[:amount] || 0).to_f
    @withdraw_amount = init_values[:withdraw_amount]
    @currency = init_values[:currency]
    @datetime = init_values[:datetime]
    @sender = init_values[:sender]
    @codepro = init_values[:codepro]
    @label = init_values[:label]
    @sha1_hash = init_values[:sha1_hash]
    @test_notification = init_values[:test_notification]
  end 
  
  def check_hash
    Digest::SHA1.hexdigest(hash_string) == sha1_hash ? true : false    
  end

  def hash_string
    str = "#{notification_type}&#{operation_id}&#{amount}&#{currency}&#{datetime}&#{sender}&#{codepro}&#{ENV['YANDEX_MY_TARIF_SECRET']}&#{label}"
#    Digest::Class.hexencode(Digest::SHA1.hexencode(str))
#    Digest::SHA1.hexdigest(str)
  end

  def persisted?
    false
  end  
end
