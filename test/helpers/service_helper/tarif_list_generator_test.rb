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
      @trg.all_services.must_be :==, [[0, 93, 77, 80, 81, 82, 83, 84, 85, 86], [100, 175, 176, 177], [200, 276, 277]]
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
#      @trg.tarif_slices.must_be :==, 1
      @trg.tarif_slices[0][1].must_be :==, {:ids=>[93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93, 93], :prev_ids=>[[77, nil, nil], [77, nil, 82], [77, nil, 83], [77, nil, 84], [77, nil, 85], [77, nil, 86], [77, 80, nil], [77, 80, 82], [77, 80, 83], [77, 80, 84], [77, 80, 85], [77, 80, 86], [77, 81, nil], [77, 81, 82], [77, 81, 83], [77, 81, 84], [77, 81, 85], [77, 81, 86]], :set_ids=>["93_77", "93_77_82", "93_77_83", "93_77_84", "93_77_85", "93_77_86", "93_77_80", "93_77_80_82", "93_77_80_83", "93_77_80_84", "93_77_80_85", "93_77_80_86", "93_77_81", "93_77_81_82", "93_77_81_83", "93_77_81_84", "93_77_81_85", "93_77_81_86"], :prev_set_ids=>["77", "77_82", "77_83", "77_84", "77_85", "77_86", "77_80", "77_80_82", "77_80_83", "77_80_84", "77_80_85", "77_80_86", "77_81", "77_81_82", "77_81_83", "77_81_84", "77_81_85", "77_81_86"]}  
      @trg.tarif_slices[0][2].must_be :==, {:ids=>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], :prev_ids=>[[93, 77, nil, nil], [93, 77, nil, 82], [93, 77, nil, 83], [93, 77, nil, 84], [93, 77, nil, 85], [93, 77, nil, 86], [93, 77, 80, nil], [93, 77, 80, 82], [93, 77, 80, 83], [93, 77, 80, 84], [93, 77, 80, 85], [93, 77, 80, 86], [93, 77, 81, nil], [93, 77, 81, 82], [93, 77, 81, 83], [93, 77, 81, 84], [93, 77, 81, 85], [93, 77, 81, 86]], :set_ids=>["0_93_77", "0_93_77_82", "0_93_77_83", "0_93_77_84", "0_93_77_85", "0_93_77_86", "0_93_77_80", "0_93_77_80_82", "0_93_77_80_83", "0_93_77_80_84", "0_93_77_80_85", "0_93_77_80_86", "0_93_77_81", "0_93_77_81_82", "0_93_77_81_83", "0_93_77_81_84", "0_93_77_81_85", "0_93_77_81_86"], :prev_set_ids=>["93_77", "93_77_82", "93_77_83", "93_77_84", "93_77_85", "93_77_86", "93_77_80", "93_77_80_82", "93_77_80_83", "93_77_80_84", "93_77_80_85", "93_77_80_86", "93_77_81", "93_77_81_82", "93_77_81_83", "93_77_81_84", "93_77_81_85", "93_77_81_86"]} 
    end
  end

  describe 'calculate_max_tarif_slice' do
    it 'must return' do
      @trg.max_tarif_slice.must_be :==, [3, 4, 3] 
    end
  end

  describe 'calculate_uniq_tarif_option_combinations' do
    it 'must return' do
      @trg.uniq_tarif_option_combinations.must_be :==, [{"82"=>[82], "83"=>[83], "84"=>[84], "85"=>[85], "86"=>[86], "80"=>[80], "80_82"=>[80, 82], "80_83"=>[80, 83], "80_84"=>[80, 84], "80_85"=>[80, 85], "80_86"=>[80, 86], "81"=>[81], "81_82"=>[81, 82], "81_83"=>[81, 83], "81_84"=>[81, 84], "81_85"=>[81, 85], "81_86"=>[81, 86]}, {}, {}] 
      @trg.max_tarif_option_combinations.must_be :==, [2, 0, 0] 
    end
  end

  describe 'calculate_tarif_options_slices' do
    it 'must return' do
      @trg.tarif_options_slices.must_be :==, [[{:ids=>[82, 83, 84, 85, 86, 80, 81], :prev_ids=>[], :set_ids=>["82", "83", "84", "85", "86", "80", "81"], :prev_set_ids=>["", "", "", "", "", "", ""]}, {:ids=>[82, 83, 84, 85, 86, 82, 83, 84, 85, 86], :prev_ids=>[81], :set_ids=>["82_80", "83_80", "84_80", "85_80", "86_80", "82_81", "83_81", "84_81", "85_81", "86_81"], :prev_set_ids=>["80", "80", "80", "80", "80", "81", "81", "81", "81", "81"]}], [], []]  
    end
  end

end

