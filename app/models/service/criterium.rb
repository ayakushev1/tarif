# == Schema Information
#
# Table name: service_criteria
#
#  id                     :integer          not null, primary key
#  service_category_id    :integer
#  criteria_param_id      :integer
#  comparison_operator_id :integer
#  value_param_id         :integer
#  value_choose_option_id :integer
#  value                  :json
#  eval_string            :text
#

class Service::Criterium < ActiveRecord::Base
  include WhereHelper, PgJsonHelper, ParameterHelper
  belongs_to :service_category, :class_name =>'Service::Category', :foreign_key => :service_category_id
  belongs_to :criteria_param, :class_name =>'Parameter', :foreign_key => :criteria_param_id
  belongs_to :comparison_operator, :class_name =>'::Category', :foreign_key => :comparison_operator_id
  belongs_to :value_param, :class_name =>'Parameter', :foreign_key => :value_param_id
  belongs_to :value_choose_option, :class_name =>'::Category', :foreign_key => :value_choose_option_id

  def where_hash(context)
    criteria_param = parameter_class_sql_name(Parameter.find(criteria_param_id), context)

    comparison_operator = ::Category.find(comparison_operator_id).name

    if value_param_id
      value_param = parameter_class_instance_value(Parameter.find(value_param_id), context, value)      
    else
      value_param = eval(eval_string)
    end
    
    case comparison_operator
    when 'in'
      "(#{criteria_param} = any('{#{value_param}}') )"
    else
      "(#{criteria_param} #{comparison_operator} '#{value_param}')"
    end
    
  end
end

