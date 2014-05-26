require 'test_helper'

describe ServiceHelper::TarifListGenerator do
  it 'must exists' do
    ServiceHelper::TarifListGenerator.must_be :==, ServiceHelper::TarifListGenerator
  end
  
  before do
    @trg = ServiceHelper::TarifListGenerator.new
  end
  
  describe 'calculate_all_services' do
    it 'must return' do
      @trg.all_services.must_be :==, [[0, 93, 77, 80, 81, 82, 83, 84, 85, 86], [100, 175, 176, 177], [200, 275, 276, 277]]
    end
  end

  describe 'calculate_all_tarif_options' do
    it 'must return' do
      @trg.calculate_all_tarif_options.must_be :==, [[80, 81, 82, 83, 84, 85, 86], [], []]
    end
  end

  describe 'tarif_option_combinations' do
    it 'must return' do
      @trg.tarif_option_combinations(@trg.tarif_options[0][0]).must_be :==, [[nil, nil], [nil, 82], [nil, 83], [nil, 84], [nil, 85], [nil, 86], [80, nil], [80, 82], [80, 83], [80, 84], [80, 85], [80, 86], [81, nil], [81, 82], [81, 83], [81, 84], [81, 85], [81, 86]]
    end
  end

  describe 'tarif_set_id' do
    it 'must return' do
      @trg.tarif_set_id([0, 75, 93, nil, 77, nil, nil, nil]).must_be :==, '0_75_93_77' 
    end
  end

  describe 'calculate_tarif_slices' do
    it 'must return' do
      @trg.tarif_slices[0][1].must_be :==, {:ids=>[93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93], :prev_ids=>[[77, nil, nil], [77, nil, 82], [77, nil, 83], [77, nil, 84], [77, nil, 85], [77, nil, 86], [77, 80, nil], [77, 80, 82], [77, 80, 83], [77, 80, 84], [77, 80, 85], [77, 80, 86], [77, 81, nil], [77, 81, 82], [77, 81, 83], [77, 81, 84], [77, 81, 85], [77, 81, 86]]} 
      @trg.tarif_slices[0][2].must_be :==, {:ids=>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], :prev_ids=>[[93, 77, nil, nil], [93, 77, nil, 82], [93, 77, nil, 83], [93, 77, nil, 84], [93, 77, nil, 85], [93, 77, nil, 86], [93, 77, 80, nil], [93, 77, 80, 82], [93, 77, 80, 83], [93, 77, 80, 84], [93, 77, 80, 85], [93, 77, 80, 86], [93, 77, 81, nil], [93, 77, 81, 82], [93, 77, 81, 83], [93, 77, 81, 84], [93, 77, 81, 85], [93, 77, 81, 86]]} 
    end
  end

end

