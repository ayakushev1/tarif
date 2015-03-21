# == Schema Information
#
# Table name: price_standard_formulas
#
#  id             :integer          not null, primary key
#  name           :string
#  formula        :json
#  price_unit_id  :integer
#  volume_id      :integer
#  volume_unit_id :integer
#  description    :text
#

class Price::StandardFormula < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  belongs_to :price_unit, :class_name =>'::Category', :foreign_key => :price_unit_id
  belongs_to :volume, :class_name =>'::Parameter', :foreign_key => :volume_id
  belongs_to :volume_unit, :class_name =>'::Category', :foreign_key => :volume_unit_id
  has_many :formulas, :class_name =>'Price::Formula', :foreign_key => :standard_formula_id

end
