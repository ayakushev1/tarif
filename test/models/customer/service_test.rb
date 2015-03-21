# == Schema Information
#
# Table name: customer_services
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  phone_number   :string
#  tarif_class_id :integer
#  tarif_list_id  :integer
#  status_id      :integer
#  valid_from     :datetime
#  valid_till     :datetime
#  description    :json
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

describe 'Customer::Service' do
  describe 'seed data' do
    it 'must exists' do
      Customer::Service.must_be :==, Customer::Service
    end 
  end

end
