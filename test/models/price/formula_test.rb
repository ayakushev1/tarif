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
