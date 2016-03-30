# == Schema Information
#
# Table name: customer_background_stats
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  result      :json
#  result_type :string
#  result_name :string
#  result_key  :json
#  created_at  :datetime
#  updated_at  :datetime
#

class Customer::BackgroundStat < ActiveRecord::Base
  include PgJsonHelper, WhereHelper, PgCreateHelper
#  serialize :result
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  
end
