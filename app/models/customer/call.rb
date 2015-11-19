# == Schema Information
#
# Table name: customer_calls
#
#  id                 :integer          not null, primary key
#  base_service_id    :integer
#  base_subservice_id :integer
#  user_id            :integer
#  own_phone          :jsonb
#  partner_phone      :jsonb
#  connect            :jsonb
#  description        :jsonb
#  call_run_id        :integer
#  calendar_period    :string
#  global_category_id :integer
#

class Customer::Call < ActiveRecord::Base
  include PgJsonHelper, WhereHelper
  extend BatchInsert
  
  belongs_to :base_service, :class_name =>'::Category', :foreign_key => :base_service_id
  belongs_to :base_subservice, :class_name =>'::Category', :foreign_key => :base_subservice_id
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :call_run, :class_name =>'Customer::CallRun', :foreign_key => :call_run_id
  
  pg_json_belongs_to :own_phone_region, :class_name => '::Category', :foreign_key => :own_phone, :field => :region_id
  pg_json_belongs_to :own_phone_operator, :class_name => '::Category', :foreign_key => :own_phone, :field => :operator_id
  pg_json_belongs_to :partner_phone_region, :class_name => '::Category', :foreign_key => :partner_phone, :field => :region_id
  pg_json_belongs_to :partner_phone_operator, :class_name => '::Category', :foreign_key => :partner_phone, :field => :operator_id
  pg_json_belongs_to :connect_phone_region, :class_name => '::Category', :foreign_key => :connect_phone, :field => :region_id
  pg_json_belongs_to :connect_phone_operator, :class_name => '::Category', :foreign_key => :connect_phone, :field => :operator_id

end

