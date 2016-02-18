class Optimization::Global::Base
  Structure = {
#    :russia => {
      :own_and_home_regions => {
        :calls_in => {},
        :calls_out => {
          :to_own_and_home_regions => {:to_operators => {}},
          :to_own_country_regions => {:to_operators => {}},
          :to_abroad_countries => {:to_operators => {}}
        },
        :sms_in => {},
        :sms_out => {:to_own_and_home_regions => {}, :to_own_country_regions => {}, :to_abroad => {}},
        :mms_in => {},
        :mms_out => {},
        :internet =>{}
      },
      :own_country_regions => {
        :calls_in => {:to_operators => {}},
        :calls_out => {
          :to_own_and_home_regions => {:to_operators => {}},
          :to_own_country_regions => {:to_operators => {}},
          :to_abroad_countries => {:to_operators => {}}
        },
        :sms_in => {},
        :sms_out => {:to_own_and_home_regions => {}, :to_own_country_regions => {}, :to_abroad => {}},
        :mms_in => {},
        :mms_out => {},
        :internet =>{}
      },
#    },
    :abroad_countries => {
#      :any_region => {
        :calls_in => {},
        :calls_out => {:to_russia => {}, :to_rouming_country => {}, :to_other_countries => {}},
        :sms_in => {},
        :sms_out => {},
        :mms_in => {},
        :mms_out => {},
        :internet =>{}
#      }
    }
  }
  
end
