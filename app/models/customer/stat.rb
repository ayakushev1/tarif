# == Schema Information
#
# Table name: customer_stats
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  phone_number :string(255)
#  filtr        :text
#  result       :json
#  stat_from    :datetime
#  stat_till    :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Customer::Stat < ActiveRecord::Base
  include PgJsonHelper, WhereHelper, PgCreateHelper
#  serialize :result
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  
end
