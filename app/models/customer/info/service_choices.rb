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
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update(:info => values)
  end
  
  def self.services_from_session_to_optimization_format(services_chosen)
    result = {:operators => [], :tarifs => {}, :tarif_options => {}, :common_services => {}, }
    
     {'tel' => 1023, 'bln' => 1025, 'mgf' => 1028, 'mts' => 1030}.each do |operator_name, operator_id|
       result[:operators] << operator_id if !services_chosen['tarifs'][operator_name].blank? 
       result[:tarifs][operator_id] = (services_chosen['tarifs'][operator_name] || []).map(&:to_i)
       result[:tarif_options][operator_id] = (services_chosen['tarif_options'][operator_name] || []).map(&:to_i)
       result[:common_services][operator_id] = (services_chosen['common_services'][operator_name] || []).map(&:to_i)
     end
    result 
  end

  def self.validate_tarifs(to_validate)
    validated_result = {'tarifs' => {}, 'tarif_options' => {}, 'common_services' => {}}
    operator = 1023
#    raise(StandardError, to_validate)
    validated_result['tarifs']['tel'] = to_validate['tarifs']['tel'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options']['tel'] = to_validate['tarif_options']['tel'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services']['tel'] = to_validate['common_services']['tel'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator] 

    operator = 1025
    validated_result['tarifs']['bln'] = to_validate['tarifs']['bln'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options']['bln'] = to_validate['tarif_options']['bln'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services']['bln'] = to_validate['common_services']['bln'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator] 

    operator = 1028
    validated_result['tarifs']['mgf'] = to_validate['tarifs']['mgf'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options']['mgf'] = to_validate['tarif_options']['mgf'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services']['mgf'] = to_validate['common_services']['mgf'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator] 

    operator = 1030
    validated_result['tarifs']['mts'] = to_validate['tarifs']['mts'].to_s.scan(/\d+/).map(&:to_i) & tarifs[operator] 
    validated_result['tarif_options']['mts'] = to_validate['tarif_options']['mts'].to_s.scan(/\d+/).map(&:to_i) & tarif_options[operator] 
    validated_result['common_services']['mts'] = to_validate['common_services']['mts'].to_s.scan(/\d+/).map(&:to_i) & common_services[operator]
    validated_result 
  end
  
  def self.default_values(user_type = :guest)
    {
      'tarifs' => {'tel' => tarifs[1023], 'bln' => tarifs[1025], 'mgf' => tarifs[1028], 'mts' => tarifs[1030]},
      'common_services' => {'tel' => common_services[1023], 'bln' => common_services[1025], 'mgf' => common_services[1028], 'mts' => common_services[1030]}, 
      'tarif_options' => {'tel' => tarif_options_for_demo(user_type)[1023], 'bln' => tarif_options_for_demo(user_type)[1025], 
                          'mgf' => tarif_options_for_demo(user_type)[1028], 'mts' => tarif_options_for_demo(user_type)[1030]}, 
    }
  end
  
  def self.default_values_for_paid
    {
      'tarifs' => {'tel' => tarifs[1023], 'bln' => tarifs[1025], 'mgf' => tarifs[1028], 'mts' => tarifs[1030]},
      'common_services' => {'tel' => common_services[1023], 'bln' => common_services[1025], 'mgf' => common_services[1028], 'mts' => common_services[1030]}, 
      'tarif_options' => {'tel' => tarif_options[1023], 'bln' => tarif_options[1025], 'mgf' => tarif_options[1028], 'mts' => tarif_options[1030]}, 
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
      1023 => [800, 801, 802, 805], #, 803, 804
      1025 => [600, 601, 602, 603, 604, 605, 610, 611, 612, 613, 622, 623, 624], #620, 621, 626
      1028 => [100, 101, 102, 103, 104, 105, 106, 107, 109, 110, 113], #108, 112,  
      1030 => [200, 201, 202, 203, 204, 205, 206, 207, 208, 212, 213, 214], #210, 
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

  def self.tarif_options_for_demo(user_type = :guest)
    demo_option_types = {:guest => [], :trial => [:calls, :sms, :internet], :user => [:international_rouming, :country_rouming, :mms, :calls, :sms, :internet],
                         :admin => [:international_rouming, :country_rouming, :mms, :calls, :sms, :internet]}[user_type]
#    demo_option_types = [:international_rouming, :country_rouming, :calls, :sms, :internet]
    {
      1023 => tarif_options_by_type[1023].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1025 => tarif_options_by_type[1025].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1028 => tarif_options_by_type[1028].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1030 => tarif_options_by_type[1030].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
    }
  end  

  def self.services_for_comparison(operators = [], tarif_options = [])
    result = {:operators => [], :tarifs => {}, :tarif_options => {}, :common_services => {}, }
    operators.each do |operator_id|
       result[:operators] << operator_id  
       result[:tarifs][operator_id] = tarifs[operator_id]
       result[:tarif_options][operator_id] = tarif_options_for_comparison(tarif_options)
       result[:common_services][operator_id] = common_services[operator_id]
    end
    result
  end
  
  def self.tarif_options_for_comparison(options_for_comparison = [])
#    options_for_comparison = [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet]
    {
      1023 => tarif_options_by_type[1023].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
      1025 => tarif_options_by_type[1025].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
      1028 => tarif_options_by_type[1028].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
      1030 => tarif_options_by_type[1030].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
    }
  end  

  def self.tarif_options_by_type
    {
      1023 => {
        :international_rouming => [890, 895],
        :country_rouming => [840],  
        :mms => [],  
        :sms => [860, 861],  
        :calls => [850],  
        :internet => [880, 881, 882, 883, 884, 885, 886],  
      },
      1025 => {
        :international_rouming => [660, 661, 662, 663],
        :country_rouming => [670, 671, 672, 673, 674],  
        :mms => [720],  
        :sms => [700, 701, 702],  
        :calls => [680, 681, 682, 683],  
        :internet => [730, 731, 732, 733, 734, 735, 736, 737, 738, 739],  
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
