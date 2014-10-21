class Customer::Info::ServicesSelect < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 9)
  end

  def self.info(user_id)
    where(:user_id => user_id).first.info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first.update(:info => values)
  end
  
  def self.default_values
    {
      'operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
      'tarifs' => 'true', 'common_services' => 'true', 'all_tarif_options' => 'false'
    }
  end

  def self.process_selecting_services(params)
    service_choices_filtr = {}
    if params
      if params['operator_bln'] == 'true'
        input = selected_services(1025, params)
        service_choices_filtr['tarifs_bln'] = input['tarifs']
        service_choices_filtr['common_services_bln'] = input['common_services']
        service_choices_filtr['tarif_options_bln'] = input['tarif_options']
      end
      if params['operator_mgf'] == 'true'
        input = selected_services(1028, params)
        service_choices_filtr['tarifs_mgf'] = input['tarifs']
        service_choices_filtr['common_services_mgf'] = input['common_services']
        service_choices_filtr['tarif_options_mgf'] = input['tarif_options']
      end
      if params['operator_mts'] == 'true'
        input = selected_services(1030, params)
        service_choices_filtr['tarifs_mts'] = input['tarifs']
        service_choices_filtr['common_services_mts'] = input['common_services']
        service_choices_filtr['tarif_options_mts'] = input['tarif_options']
      end
    end
    service_choices_filtr
  end
  
  def self.selected_services(operator, params)
    result = {}
    result['tarifs'] = (params['tarifs'] == 'true') ? Customer::Info::ServiceChoices.tarifs[operator] : []
    result['common_services'] = (params['common_services'] == 'true') ? Customer::Info::ServiceChoices.common_services[operator] : []
    if params['all_tarif_options'] == 'true'
      result['tarif_options'] = Customer::Info::ServiceChoices.tarif_options[operator]
    else
      result['tarif_options'] = []
      existing_tarif_options = Customer::Info::ServiceChoices.tarif_options_by_type[operator]
      result['tarif_options'] += (params['international_rouming'] == 'true') ? existing_tarif_options[:international_rouming] : []
      result['tarif_options'] += (params['country_rouming'] == 'true') ? existing_tarif_options[:country_rouming] : []
      result['tarif_options'] += (params['calls'] == 'true') ? existing_tarif_options[:calls] : []
      result['tarif_options'] += (params['internet'] == 'true') ? existing_tarif_options[:internet] : []
      result['tarif_options'] += (params['sms'] == 'true') ? existing_tarif_options[:sms] : []
      result['tarif_options'] += (params['mms'] == 'true') ? existing_tarif_options[:mms] : []      
      result['tarif_options'].uniq!
    end
    result
  end
  
end