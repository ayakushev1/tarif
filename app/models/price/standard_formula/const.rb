module Price::StandardFormula::Const
  PriceByMonth = 0
  PriceByItem = 2

  PriceBySumDurationSecond = 13
  PriceByCountVolumeItem = 14

  PriceBySumVolumeMByte = 15
  PriceBySumVolumeKByte = 16
  PriceBySumDuration = 17

  FixedPriceIfUsedInOneDayDuration = 18
  FixedPriceIfUsedInOneDayVolume = 19
  FixedPriceIfUsedInOneDayAny = 20
  PriceByMonthIfUsed = 21
  PriceByItemIfUsed = 22

  MaxVolumesForFixedPriceConst = [30, 31, 32]
  MaxDurationMinuteForFixedPrice = 30
  MaxCountVolumeForFixedPrice = 31
  MaxSumVolumeMByteForFixedPrice = 32
  
  MaxVolumesForFixedPriceIfUsedConst = [33, 34, 35]
  MaxDurationMinuteForFixedPriceIfUsed = 33
  MaxCountVolumeForFixedPriceIfUsed = 34
  MaxSumVolumeMByteForFixedPriceIfUsed = 35

  MaxDurationMinuteForSpecialPrice = 36
  MaxCountVolumeForSpecialPrice = 37
  MaxSumVolumeMByteForSpecialPrice = 38

  TurbobuttonsConst = [40, 41]
  TurbobuttonMByteForFixedPrice = 40
  TurbobuttonMByteForFixedPriceDay = 41

#  MaxDurationMinuteWithMultipleUseMonth = 50
#  MaxDurationMinuteWithMultipleUseDay = 51

  MaxCountVolumeWithMultipleUseMonth = 52
  MaxCountVolumeWithMultipleUseDay = 53

  MaxSumVolumeMByteWithMultipleUseMonth = 54
  MaxSumVolumeMByteWithMultipleUseDay = 55
  
  TwoStepPriceMaxDurationMinute = 61

  TwoStepPriceDurationMinute = 70
  ThreeStepPriceDurationMinute = 71
  
  
end

  
#  _stf_zero_count_volume_item = 11;  _stf_zero_sum_volume_m_byte = 12;
#  _stf_price_by_sum_duration_second = 13; _stf_price_by_count_volume_item = 14; _stf_price_by_sum_volume_m_byte = 15; _stf_price_by_sum_volume_k_byte = 16 
#  _stf_price_by_sum_duration_minute = 17; _stf_fixed_price_if_used_in_1_day_duration = 18; _stf_fixed_price_if_used_in_1_day_volume = 19;
#  _stf_price_by_1_month_if_used = 20; _stf_price_by_1_item_if_used = 21; _stf_fixed_price_if_used_in_1_day_any = 22;
  
