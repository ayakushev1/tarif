# == Schema Information
#
# Table name: visits
#
#  id               :uuid             not null, primary key
#  visitor_id       :uuid
#  ip               :string(255)
#  user_agent       :text
#  referrer         :text
#  landing_page     :text
#  user_id          :integer
#  referring_domain :string(255)
#  search_keyword   :string(255)
#  browser          :string(255)
#  os               :string(255)
#  device_type      :string(255)
#  country          :string(255)
#  region           :string(255)
#  city             :string(255)
#  utm_source       :string(255)
#  utm_medium       :string(255)
#  utm_term         :string(255)
#  utm_content      :string(255)
#  utm_campaign     :string(255)
#  started_at       :datetime
#

class Visit < ActiveRecord::Base
  has_many :ahoy_events, class_name: "Ahoy::Event"
  belongs_to :user
end
