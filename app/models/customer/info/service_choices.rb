# == Schema Information
#
# Table name: customer_infos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime
#

class Customer::Info::ServiceChoices < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 8)
  end
  
  def self.info(user_id)
    where(:user_id => user_id).first.info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first.update(:info => values)
  end
  
  def self.validate_tarifs(to_validate)
    validated_result = {}
    operator = 1023
    validated_result['tarifs_tel'] = to_validate['tarifs_tel'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options_tel'] = to_validate['tarif_options_tel'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services_tel'] = to_validate['common_services_tel'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator] 

    operator = 1025
    validated_result['tarifs_bln'] = to_validate['tarifs_bln'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options_bln'] = to_validate['tarif_options_bln'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services_bln'] = to_validate['common_services_bln'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator] 

    operator = 1028
    validated_result['tarifs_mgf'] = to_validate['tarifs_mgf'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options_mgf'] = to_validate['tarif_options_mgf'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services_mgf'] = to_validate['common_services_mgf'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator] 

    operator = 1030
    validated_result['tarifs_mts'] = to_validate['tarifs_mts'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options_mts'] = to_validate['tarif_options_mts'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services_mts'] = to_validate['common_services_mts'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator]
    validated_result 
  end
  
  def self.default_values
    {
      'tarifs_tel' => tarifs[1023], 'tarifs_bln' => tarifs[1025], 'tarifs_mgf' => tarifs[1028], 'tarifs_mts' => tarifs[1030],
      'common_services_tel' => common_services[1023], 'common_services_bln' => common_services[1025], 'common_services_mgf' => common_services[1028], 'common_services_mts' => common_services[1030], 
      'tarif_options_tel' => tarif_options_for_demo[1023], 'tarif_options_bln' => tarif_options_for_demo[1025], 'tarif_options_mgf' => tarif_options_for_demo[1028], 'tarif_options_mts' => tarif_options_for_demo[1030], 
#      'accounting_period' => -1,
      'calculate_only_chosen_services' => 'false',
      'calculate_with_limited_scope' => 'false',
      'calculate_with_fixed_services' => 'false'
    }
  end
  
  def self.default_values_for_paid
    {
      'tarifs_tel' => tarifs[1023], 'tarifs_bln' => tarifs[1025], 'tarifs_mgf' => tarifs[1028], 'tarifs_mts' => tarifs[1030],
      'common_services_tel' => common_services[1023], 'common_services_bln' => common_services[1025], 'common_services_mgf' => common_services[1028], 'common_services_mts' => common_services[1030], 
      'tarif_options_tel' => tarif_options[1023], 'tarif_options_bln' => tarif_options[1025], 'tarif_options_mgf' => tarif_options[1028], 'tarif_options_mts' => tarif_options[1030], 
#      'accounting_period' => -1,
      'calculate_only_chosen_services' => 'false',
      'calculate_with_limited_scope' => 'false',
      'calculate_with_fixed_services' => 'false'
    }
  end
  
  def self.operators
    [1023, 1025, 1028, 1030]
  end
  
  def self.all_services_by_operator
    result = {}
    operators.each do |operator|
      result[operator] = tarifs[operator] + common_services[operator] + tarif_options[operator]
    end
    result
  end

  def self.tarifs
    {
      1023 => [800, 801, 802, 803, 804],
      1025 => [600, 601, 602, 603, 604, 605, 610, 611, 612, 613, 621, 622, 623, 624], #620, 626
      1028 => [100, 101, 102, 103, 104, 105, 106, 107, 109, 110, 113], #108, 112,  
      1030 => [200, 201, 202, 203, 204, 205, 206, 207, 208, 210, 212, 213, 214],
    }
  end  

  def self.common_services
    {
      1023 => [830, 831, 832],
      1025 => [650, 651, 652, 653, 654, 655],
      1028 => [174, 177, 178, 179],
      1030 => [276, 277, 312, 297],
    }
  end  

  def self.tarif_options
    {
      1023 => tarif_options_by_type[1023].map{|t| t[1]}.flatten.compact,
      1025 => tarif_options_by_type[1025].map{|t| t[1]}.flatten.compact,
      1028 => tarif_options_by_type[1028].map{|t| t[1]}.flatten.compact,
      1030 => tarif_options_by_type[1030].map{|t| t[1]}.flatten.compact,
    }
  end  

  def self.tarif_options_for_demo
    demo_option_types = [:calls]
#    demo_option_types = [:international_rouming, :country_rouming, :calls, :sms, :internet]
    {
      1023 => tarif_options_by_type[1023].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1025 => tarif_options_by_type[1025].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1028 => tarif_options_by_type[1028].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1030 => tarif_options_by_type[1030].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
    }
  end  

  def self.tarif_options_by_type
    {
      1023 => {
        :international_rouming => [],
        :country_rouming => [840],  
        :mms => [],  
        :sms => [860],  
        :calls => [],  
        :internet => [880, 881, 882, 883],  
      },
      1025 => {
        :international_rouming => [660, 661, 662, 663],
        :country_rouming => [670],  
        :mms => [720],  
        :sms => [700, 701, 702],  
        :calls => [680, 681, 682, 683],  
        :internet => [730, 731, 732, 733, 734, 735, 736],  
      },
      1028 => {
        :international_rouming => [
          400, 401, 402, 403, 404, 405, 406, 407, #calls
          410, 411, 412, 413, #sms
          430, 431, 432, #internet
          ],
        :country_rouming => [440, 441, 442, 443, 444, 445, 493],  
        :mms => [450, 451, 452],  
        :sms => [455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466],  
        :calls => [470, 471, 472, 473, 489, 490, 491, 492],  
        :internet => [475, 476, 477, 478, 479, 480, 481, 482, 484, 485, 486, 487, 488],  
      },
      1030 => {
        :international_rouming => [288, 289, 290, 291, 292, 347],
        :country_rouming => [294, 282, 283, 321, 322, 348],  
        :mms => [323, 324, 325, 326],  
        :sms => [295, 296, 305, 306, 307, 308, 333, 334, 335, 336, 337, 338, 339, 346],  
        :calls => [328, 329, 330, 331, 332, 281, 309, 293, 280],  
        :internet => [302, 303, 304, 310, 311, 313, 314, 315, 316, 317, 318, 340, 341, 342, 319, 320, 343, 344, 345],  
      },
    }
  end  

end
