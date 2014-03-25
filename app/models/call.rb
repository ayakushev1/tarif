# == Schema Information
#
# Table name: calls
#
#  id                 :integer          not null, primary key
#  base_service_id    :integer
#  base_subservice_id :integer
#  user_id            :integer
#  own_phone          :json
#  partner_phone      :json
#  connect            :json
#  description        :json
#

class Call < ActiveRecord::Base
  include PgJsonHelper, WhereHelper
  belongs_to :base_service, :class_name =>'Category', :foreign_key => :base_service_id
  belongs_to :base_subservice, :class_name =>'Category', :foreign_key => :base_subservice_id
  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  
  pg_json_belongs_to :own_phone_region, :class_name => 'Category', :foreign_key => :own_phone, :field => :region_id
  pg_json_belongs_to :own_phone_operator, :class_name => 'Category', :foreign_key => :own_phone, :field => :operator_id
  pg_json_belongs_to :partner_phone_region, :class_name => 'Category', :foreign_key => :partner_phone, :field => :region_id
  pg_json_belongs_to :partner_phone_operator, :class_name => 'Category', :foreign_key => :partner_phone, :field => :operator_id
  pg_json_belongs_to :connect_phone_region, :class_name => 'Category', :foreign_key => :connect_phone, :field => :region_id
  pg_json_belongs_to :connect_phone_operator, :class_name => 'Category', :foreign_key => :connect_phone, :field => :operator_id

end

