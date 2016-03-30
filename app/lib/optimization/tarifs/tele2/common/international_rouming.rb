class Optimization::Tarifs::Tele2::Tarif < Optimization::Tarifs::BaseTarif
  o = Category::Country::Tel
  Black = {
    :id => 831,
    :groups => {
      :_sctcg_SIC_calls_incoming => [
        [{:global => [:abroad_countries, :any_region, :calls_in], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_calls_to_all_own_country_regions => [
        [{:global => [:abroad_countries, :any_region, :calls_out, :to_russia], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_calls_to_rouming_country => [
        [{:global => [:abroad_countries, :any_region, :calls_out, :to_rouming_country], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_calls_to_sic => [
        [{:global => [:abroad_countries, :any_region, :calls_out, :to_other_countries], :filtr => {
          :abroad_countries => {:in => [o::Service_to_tele_international_1]}, :to_other_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_calls_to_europe => [
        [{:global => [:abroad_countries, :any_region, :calls_out, :to_other_countries], :filtr => {
          :abroad_countries => {:in => [o::Service_to_tele_international_1]}, :to_other_countries => {:in => [o::Service_to_tele_international_2]}}}]
      ],
      :_sctcg_SIC_calls_to_asia_afr_austr => [
        [{:global => [:abroad_countries, :any_region, :calls_out, :to_other_countries], :filtr => {
          :abroad_countries => {:in => [o::Service_to_tele_international_1]}, :to_other_countries => {:in => [o::Service_to_tele_international_5]}}}]
      ],
      :_sctcg_SIC_calls_to_americas => [
        [{:global => [:abroad_countries, :any_region, :calls_out, :to_other_countries], :filtr => {
          :abroad_countries => {:in => [o::Service_to_tele_international_1]}, :to_other_countries => {:in => [o::Service_to_tele_international_6]}}}]
      ],
      :_sctcg_SIC_sms_incoming => [
        [{:global => [:abroad_countries, :any_region, :sms_in], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_sms_outcoming => [
        [{:global => [:abroad_countries, :any_region, :sms_out], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_mms_incoming => [
        [{:global => [:abroad_countries, :any_region, :mms_in], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_mms_outcoming => [
        [{:global => [:abroad_countries, :any_region, :mms_out], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
      :_sctcg_SIC_internet => [
        [{:global => [:abroad_countries, :any_region, :internet], :filtr => {:abroad_countries => {:in => [o::Service_to_tele_international_1]}}}]
      ],
    }
  }

end

