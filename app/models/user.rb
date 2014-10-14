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

  has_many :customer_infos_general, -> {where(:info_type_id => 1)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_cash, -> {where(:info_type_id => 2)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_services_used, -> {where(:info_type_id => 3)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_calls_generation_params, -> {where(:info_type_id => 4)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_calls_details_params, -> {where(:info_type_id => 5)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_calls_parsing_params, -> {where(:info_type_id => 6)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_tarif_optimization_params, -> {where(:info_type_id => 7)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_service_choices, -> {where(:info_type_id => 8)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_services_select, -> {where(:info_type_id => 9)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_service_categories_select, -> {where(:info_type_id => 10)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_tarif_optimization_final_results, -> {where(:info_type_id => 11)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_tarif_optimization_minor_results, -> {where(:info_type_id => 12)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_infos_tarif_optimization_process_status, -> {where(:info_type_id => 13)}, :class_name =>'Customer::Info', :foreign_key => :user_id, :dependent => :delete_all

  has_many :customer_transactions_general, -> {where(:info_type_id => 1)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_cash, -> {where(:info_type_id => 2)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_services_used, -> {where(:info_type_id => 3)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_calls_generation_params, -> {where(:info_type_id => 4)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_calls_details_params, -> {where(:info_type_id => 5)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_calls_parsing_params, -> {where(:info_type_id => 6)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_tarif_optimization_params, -> {where(:info_type_id => 7)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_service_choices, -> {where(:info_type_id => 8)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_services_select, -> {where(:info_type_id => 9)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_service_categories_select, -> {where(:info_type_id => 10)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_tarif_optimization_final_results, -> {where(:info_type_id => 11)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_tarif_optimization_minor_results, -> {where(:info_type_id => 12)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all
  has_many :customer_transactions_tarif_optimization_process_status, -> {where(:info_type_id => 13)}, :class_name =>'Customer::Transaction', :foreign_key => :user_id, :dependent => :delete_all

#  validates :name, presence: true, uniqueness: true, :length => {:within => 3..40}
#  validates :password, presence: true, :confirmation => true, :length => {:within => 3..40}
#  validates_format_of :name, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'необходимо ввести электронный адрес'#, on: :create
#  validates_confirmation_of :password_digest, message: 'should match confirmation'
#  validates_length_of :name, :password_digest, within: 3..20, too_long: 'pick a shorter name', too_short: 'pick a longer name'
#  has_secure_password
  
end

