require 'test_helper'

describe 'Customer::Service' do
  describe 'seed data' do
    it 'must exists' do
      Customer::Service.must_be :==, Customer::Service
    end 
  end

end
