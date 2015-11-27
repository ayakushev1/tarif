# == Schema Information
#
# Table name: comparison_optimization_types
#
#  id                       :integer          not null, primary key
#  name                     :string
#  for_service_categories   :jsonb
#  for_services_by_operator :jsonb
#

class Comparison::OptimizationType < ActiveRecord::Base
  has_many :optimizations, :class_name =>'Comparison::Optimization', :foreign_key => :optimization_type_id
  
end

