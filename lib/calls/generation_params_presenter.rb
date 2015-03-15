class Calls::GenerationParamsPresenter
  attr_reader :g, :ccgp
  
  def initialize(calls_generator, customer_calls_generation_params)
    @g = calls_generator
    @ccgp = customer_calls_generation_params
  end
  
  def report
    result = []
    result << {:param => 'Количество дней'}.merge(days_by_rouming) 
    result << {:param => 'Общая продолжительность звонков, мин'}.merge(total_call_duration_by_rouming) 
    result << {:param => 'Продолжительность исходящих звонков, мин'}.merge(total_outcoming_call_duration_by_rouming) 
    result << {:param => 'Продолжительность исходящих звонков на выбранного оператора, мин'}.merge(total_call_duration_to_own_operator_by_rouming) 
    result << {:param => 'Продолжительность исходящих звонков на остальных операторов, мин'}.merge(total_call_duration_to_other_operators_by_rouming) 
    result << {:param => 'Продолжительность исходящих звонков на фиксированную линию, мин'}.merge(total_call_duration_to_fixed_line_by_rouming) 
    result << {:param => 'Продолжительность исходящих звонков по России, мин'}.merge(total_regional_call_duration_by_rouming) 
    result << {:param => 'Продолжительность исходящих звонков заграницу, мин'}.merge(total_international_call_duration_by_rouming) 
    result << {:param => 'Количество исходящих смс, шт'}.merge(total_outcoming_sms_by_rouming) 
    result << {:param => 'Количество исходящих ммс, шт'}.merge(total_outcoming_mms_by_rouming) 
    result << {:param => 'Объем интернет-трафика, Гб'}.merge(total_internet_volume_by_rouming) 
  end  
  
  def days_by_rouming
    total_share = ccgp[:general]['share_of_time_in_own_region'].to_f + ccgp[:general]['share_of_time_in_home_region'].to_f +
                  ccgp[:general]['share_of_time_in_own_country'].to_f + ccgp[:general]['share_of_time_abroad'].to_f
    {
      :own_region => ccgp[:general]['share_of_time_in_own_region'].to_f * g.common_params['number_of_days_in_call_list'] / total_share,
      :home_region => ccgp[:general]['share_of_time_in_home_region'].to_f * g.common_params['number_of_days_in_call_list'] / total_share,
      :own_country => ccgp[:general]['share_of_time_in_own_country'].to_f * g.common_params['number_of_days_in_call_list'] / total_share,
      :abroad => ccgp[:general]['share_of_time_abroad'].to_f * g.common_params['number_of_days_in_call_list'] / total_share,
    }
  end
  
  def day_call_duration_by_rouming
    {
      :own_region => ccgp[:own_region]['number_of_day_calls'].to_f * ccgp[:own_region]['duration_of_calls'].to_f,
      :home_region => ccgp[:home_region]['number_of_day_calls'].to_f * ccgp[:home_region]['duration_of_calls'].to_f,
      :own_country => ccgp[:own_country]['number_of_day_calls'].to_f * ccgp[:own_country]['duration_of_calls'].to_f,
      :abroad => ccgp[:abroad]['number_of_day_calls'].to_f * ccgp[:abroad]['duration_of_calls'].to_f,
    }
  end
  
  def total_call_duration_by_rouming
    {
      :own_region => days_by_rouming[:own_region] * day_call_duration_by_rouming[:own_region],
      :home_region => days_by_rouming[:home_region] * day_call_duration_by_rouming[:home_region],
      :own_country => days_by_rouming[:own_country] * day_call_duration_by_rouming[:own_country],
      :abroad => days_by_rouming[:abroad] * day_call_duration_by_rouming[:abroad],      
    }
  end

  def total_outcoming_call_duration_by_rouming
    result = {}
    total_call_duration_by_rouming.each{|key, value| result[key] = value * (1.0 - ccgp[key]['share_of_incoming_calls'].to_f)}
    result
  end

  def total_call_duration_to_own_operator_by_rouming
    {
      :own_region => (total_outcoming_call_duration_by_rouming[:own_region] - total_call_duration_to_other_operators_by_rouming[:own_region] - total_call_duration_to_fixed_line_by_rouming[:own_region]),
      :home_region => (total_outcoming_call_duration_by_rouming[:home_region] - total_call_duration_to_other_operators_by_rouming[:home_region] - total_call_duration_to_fixed_line_by_rouming[:home_region]),
      :own_country => (total_outcoming_call_duration_by_rouming[:own_country] - total_call_duration_to_other_operators_by_rouming[:own_country] - total_call_duration_to_fixed_line_by_rouming[:own_country]),
      :abroad => (total_outcoming_call_duration_by_rouming[:abroad] - total_call_duration_to_other_operators_by_rouming[:abroad] - total_call_duration_to_fixed_line_by_rouming[:abroad]),      
    }
  end

  def total_call_duration_to_other_operators_by_rouming
    {
      :own_region => total_outcoming_call_duration_by_rouming[:own_region] * ccgp[:own_region]['share_of_calls_to_other_mobile'].to_f,
      :home_region => total_outcoming_call_duration_by_rouming[:home_region] * ccgp[:home_region]['share_of_calls_to_other_mobile'].to_f,
      :own_country => total_outcoming_call_duration_by_rouming[:own_country] * ccgp[:own_country]['share_of_calls_to_other_mobile'].to_f,
      :abroad => total_outcoming_call_duration_by_rouming[:abroad] * ccgp[:abroad]['share_of_calls_to_other_mobile'].to_f,      
    }
  end
  
  def total_call_duration_to_fixed_line_by_rouming
    {
      :own_region => total_outcoming_call_duration_by_rouming[:own_region] * ccgp[:own_region]['share_of_calls_to_fix_line'].to_f,
      :home_region => total_outcoming_call_duration_by_rouming[:home_region] * ccgp[:home_region]['share_of_calls_to_fix_line'].to_f,
      :own_country => total_outcoming_call_duration_by_rouming[:own_country] * ccgp[:own_country]['share_of_calls_to_fix_line'].to_f,
      :abroad => total_outcoming_call_duration_by_rouming[:abroad] * ccgp[:abroad]['share_of_calls_to_fix_line'].to_f,      
    }
  end
  
  def total_regional_call_duration_by_rouming
    {
      :own_region => total_outcoming_call_duration_by_rouming[:own_region] * ccgp[:own_region]['share_of_regional_calls'].to_f,
      :home_region => total_outcoming_call_duration_by_rouming[:home_region] * ccgp[:home_region]['share_of_regional_calls'].to_f,
      :own_country => total_outcoming_call_duration_by_rouming[:own_country] * ccgp[:own_country]['share_of_regional_calls'].to_f,
      :abroad => total_outcoming_call_duration_by_rouming[:abroad] * ccgp[:abroad]['share_of_regional_calls'].to_f,      
    }
  end
  
  def total_share_of_outcoming_calls
    1.0
  end
  
  def total_international_call_duration_by_rouming
    {
      :own_region => total_outcoming_call_duration_by_rouming[:own_region] * ccgp[:own_region]['share_of_international_calls'].to_f,
      :home_region => total_outcoming_call_duration_by_rouming[:home_region] * ccgp[:home_region]['share_of_international_calls'].to_f,
      :own_country => total_outcoming_call_duration_by_rouming[:own_country] * ccgp[:own_country]['share_of_international_calls'].to_f,
      :abroad => total_outcoming_call_duration_by_rouming[:abroad] * ccgp[:abroad]['share_of_international_calls'].to_f,      
    }
  end
  
  def total_outcoming_sms_by_rouming
    {
      :own_region => days_by_rouming[:own_region] * (1.0 - ccgp[:own_region]['share_of_incoming_calls'].to_f) * ccgp[:own_region]['number_of_sms_per_day'].to_f,
      :home_region => days_by_rouming[:home_region] * (1.0 - ccgp[:home_region]['share_of_incoming_calls'].to_f) * ccgp[:home_region]['number_of_sms_per_day'].to_f,
      :own_country => days_by_rouming[:own_country] * (1.0 - ccgp[:own_country]['share_of_incoming_calls'].to_f) * ccgp[:own_country]['number_of_sms_per_day'].to_f,
      :abroad => days_by_rouming[:abroad] * (1.0 - ccgp[:abroad]['share_of_incoming_calls'].to_f) * ccgp[:abroad]['number_of_sms_per_day'].to_f,      
    }
  end
  
  def total_outcoming_mms_by_rouming
    {
      :own_region => days_by_rouming[:own_region] * (1.0 - ccgp[:own_region]['share_of_incoming_calls'].to_f) * ccgp[:own_region]['number_of_mms_per_day'].to_f,
      :home_region => days_by_rouming[:home_region] * (1.0 - ccgp[:home_region]['share_of_incoming_calls'].to_f) * ccgp[:home_region]['number_of_mms_per_day'].to_f,
      :own_country => days_by_rouming[:own_country] * (1.0 - ccgp[:own_country]['share_of_incoming_calls'].to_f) * ccgp[:own_country]['number_of_mms_per_day'].to_f,
      :abroad => days_by_rouming[:abroad] * (1.0 - ccgp[:abroad]['share_of_incoming_calls'].to_f) * ccgp[:abroad]['number_of_mms_per_day'].to_f,      
    }
  end
  
  def total_internet_volume_by_rouming
    {
      :own_region => ccgp[:own_region]['internet_trafic_per_month'].to_f,
      :home_region => ccgp[:home_region]['internet_trafic_per_month'].to_f,
      :own_country => ccgp[:own_country]['internet_trafic_per_month'].to_f,
      :abroad => ccgp[:abroad]['internet_trafic_per_month'].to_f,      
    }
  end
  
end
