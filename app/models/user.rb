# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  password_digest        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  description            :json
#  location_id            :integer
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
  include PgJsonHelper, WhereHelper

  belongs_to :customer_info, :class_name =>'Customer::Info', :foreign_key => :user_id
  belongs_to :customer_transaction, :class_name =>'Customer::Transaction', :foreign_key => :user_id
  
#  validates :name, presence: true, uniqueness: true, :length => {:within => 3..40}
#  validates :password, presence: true, :confirmation => true, :length => {:within => 3..40}
#  validates_format_of :name, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'необходимо ввести электронный адрес'#, on: :create
#  validates_confirmation_of :password_digest, message: 'should match confirmation'
#  validates_length_of :name, :password_digest, within: 3..20, too_long: 'pick a shorter name', too_short: 'pick a longer name'
#  has_secure_password
  
end

