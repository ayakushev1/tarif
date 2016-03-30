require 'test_helper'

describe Customer::Payment < ActiveSupport::TestCase do
  describe 'attributes' do
    before  do
      @instruction = Customer::Payment.new()
      @default_values = {
        :action => "https://money.yandex.ru/quickpay/confirm.xml",
        :receiver => "410011358898478",
        :formcomment => "Проект www.mytrifs.ru",
        :short_dest => "Проект www.mytrifs.ru, перевод средств",
        :label => "",
        :quickpay_form => "shop",
        :targets => "www.mytarifs.ru Перевод средств",
        :sum => 100.00,
        :paymentType => "PC",
        :successURL => "www.mytarifs.ru/customer/payments/wait_for_payment_being_processed"
      }
    end
    
    it 'must have all attributes with defualt values' do      
      @default_values.each do |key, value|
        value.must_be :==, @instruction.send(key)
      end 
    end 

    describe 'attribute sum' do    
      it  'must validate sum to be numeric' do      
        @instruction.sum = 'ssss' 
        @instruction.valid?
        @instruction.errors.messages[:sum].count.must_be :!=, 0
      end
      
      it  'must validate sum to be more than 100.0' do      
        @instruction.sum = 99.00
        @instruction.valid?
        @instruction.errors.messages[:sum].count.must_be :!=, 0
      end
      
      it  'must be ok if sum more than 100.0' do      
        @instruction.sum = 100.00
        @instruction.valid?
        @instruction.errors.messages[:sum].must_be_nil
      end
    end

    describe 'attribute paymentType' do
      it  'must validate to be one from AC or PC' do
        @instruction.paymentType = 'AA'
        @instruction.valid?
        @instruction.errors.messages[:paymentType].count.must_be :==, 1, @instruction.errors.messages[:paymentType]
      end

      it  'must be ok if one of AC or PC' do
        @instruction.paymentType = 'AC'
        @instruction.valid?
        @instruction.errors.messages[:paymentType].must_be_nil
      end
    end
    
  end

end
