# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  description     :json
#  location_id     :integer
#

class User < ActiveRecord::Base
  include PgJsonHelper, WhereHelper
  
  validates :name, presence: true, uniqueness: true
  has_secure_password
  
end

