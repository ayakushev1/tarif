class Optimization::Tarifs::Tele2::Tarif < Optimization::Tarifs::BaseTarif
  Black = {
    :id => 800,
    :groups => {
      :scg_tele_black_sms => [
        [{:global => [:russia, :own_and_home_regions, :sms_out, :to_own_and_home_regions], :filtr => {}}]        
      ],
      :scg_tele_black_internet => [
        [{:global => [:russia, :own_and_home_regions, :internet], :filtr => {}},
        {:global => [:russia, :own_country_regions, :internet], :filtr => {}},]
      ],
      :sctcg_own_home_regions_calls_incoming => [
        [{:global => [:russia, :own_and_home_regions, :calls_in], :filtr => {}}]        
      ],
      :_sctcg_own_home_regions_calls_to_own_home_regions_own_operator => [
        [{:global => [:russia, :own_and_home_regions, :calls_out, :to_own_and_home_regions, :to_mobile_operators], :filtr => {:to_mobile_operators => {:in => [operator_id] }}}]        
      ], 
      :_sctcg_own_home_regions_calls_to_own_country_own_operator => [
        [{:global => [:russia, :own_and_home_regions, :calls_out, :to_own_and_home_regions, :to_mobile_operators], :filtr => {:to_mobile_operators => {:not_in => [operator_id] }}}]        
      ], 
      :_sctcg_own_home_regions_calls_to_own_home_regions_not_own_operator => [
        [{:global => [:russia, :own_and_home_regions, :calls_out, :to_own_and_home_regions, :to_mobile_operators], :filtr => {:to_mobile_operators => {:not_in => [operator_id] }}},        
         {:global => [:russia, :own_and_home_regions, :calls_out, :to_own_and_home_regions, :to_fix_line], :filtr => {}}]        
      ], 
      :_sctcg_own_home_regions_calls_to_own_country_to_own_operator => [
        [{:global => [:russia, :own_and_home_regions, :calls_out, :to_own_country_regions, :to_operators], :filtr => {:to_operators => {:in => [operator_id] }}}]        
      ], 
      :_sctcg_own_home_regions_calls_to_own_country_to_not_own_operator => [
        [{:global => [:russia, :own_and_home_regions, :calls_out, :to_own_country_regions, :to_operators], :filtr => {:to_operators => {:not_in => [operator_id] }}}]        
      ], 
    }
  }

end
