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
  
  validates :name, presence: true, uniqueness: true, :length => {:within => 3..40}
  validates :password, presence: true, :confirmation => true, :length => {:within => 3..40}
  validates_format_of :name, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'необходимо ввести электронный адрес'#, on: :create
#  validates_confirmation_of :password_digest, message: 'should match confirmation'
#  validates_length_of :name, :password_digest, within: 3..20, too_long: 'pick a shorter name', too_short: 'pick a longer name'
  has_secure_password
  
end

