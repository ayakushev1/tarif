# == Schema Information
#
# Table name: price_formulas
#
#  id                  :integer          not null, primary key
#  name                :string
#  price_list_id       :integer
#  calculation_order   :integer
#  standard_formula_id :integer
#  formula             :json
#  price               :decimal(, )
#  price_unit_id       :integer
#  volume_id           :integer
#  volume_unit_id      :integer
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#

require 'test_helper'

describe 'Price::Formula' do
  describe 'class methods' do
    describe 'find_ids_by_tarif_class_ids' do
      it 'must return array' do
        Price::Formula.find_ids_by_tarif_class_ids(203).is_a?(Array).must_be :==, true
      end
      
    end

  end

end
