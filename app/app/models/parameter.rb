# == Schema Information
#
# Table name: parameters
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :string
#  nick_name      :string
#  source_type_id :integer
#  source         :json
#  display        :json
#  unit           :json
#

class Parameter < ActiveRecord::Base
  include PgJsonHelper, WhereHelper
  belongs_to :source_type, :class_name =>'Category', :foreign_key => :source_type_id
  
  pg_json_belongs_to :source_field_type, :class_name => 'Category', :foreign_key => :source, :field => :field_type_id
  pg_json_belongs_to :source_sub_field_type, :class_name => 'Category', :foreign_key => :source, :field => :sub_field_type_id
  pg_json_belongs_to :display_field_display_type, :class_name => 'Category', :foreign_key => :display, :field => :display_type_id
  pg_json_belongs_to :unit_unit, :class_name => 'Category', :foreign_key => :unit, :field => :unit_id

end
