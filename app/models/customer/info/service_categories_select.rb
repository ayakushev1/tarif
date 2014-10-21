class Customer::Info::ServiceCategoriesSelect < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 10)
  end

  def self.info(user_id)
    where(:user_id => user_id).first.info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first.update(:info => values)
  end
  
  def self.default_values
    selected_services_to_session_format
  end

  def self.selected_services_to_session_format(selected_services = default_selected_categories)
    session_selected_services = {} 
    selected_services.each do |rouming_category_name, service_categories|
      session_selected_services[rouming_category_name.to_s] ||= {}
      session_selected_services[rouming_category_name.to_s]['is_chosen'] = (service_categories[:is_chosen] == true ? 'true' : 'false')
      service_categories.each do |service_category_name, geo_categories|
        next if service_category_name == :is_chosen
        session_selected_services[rouming_category_name.to_s][service_category_name.to_s] ||= {}
        session_selected_services[rouming_category_name.to_s][service_category_name.to_s]['is_chosen'] = (geo_categories[:is_chosen] == true ? 'true' : 'false')
        geo_categories.each do |geo_category_name, partner_categories|
          next if geo_category_name == :is_chosen
          session_selected_services[rouming_category_name.to_s][service_category_name.to_s][geo_category_name.to_s] ||= {}
          session_selected_services[rouming_category_name.to_s][service_category_name.to_s][geo_category_name.to_s]['is_chosen'] = (partner_categories[:is_chosen] == true ? 'true' : 'false')
          partner_categories.each do |partner_category_name, partner_category|
            next if partner_category_name == :is_chosen
            session_selected_services[rouming_category_name.to_s][service_category_name.to_s][geo_category_name.to_s][partner_category_name.to_s] = partner_category
          end
        end           
      end if service_categories
    end if selected_services
#    raise(StandardError)
    session_selected_services
  end
  
  def self.selected_services_from_session_format(session_selected_services)
    selected_services = default_selected_categories 
    session_selected_services.each do |rouming_category_name, service_categories|
      next if rouming_category_name == 'is_chosen'
      selected_services[rouming_category_name.to_sym] ||= {}
      selected_services[rouming_category_name.to_sym][:is_chosen] = (service_categories['is_chosen'] == 'true' ? true : false)
      service_categories.each do |service_category_name, geo_categories|
        next if service_category_name == 'is_chosen'
        selected_services[rouming_category_name.to_sym][service_category_name.to_sym] ||= {}
        selected_services[rouming_category_name.to_sym][service_category_name.to_sym][:is_chosen] = (geo_categories['is_chosen'] == 'true' ? true : false)
        geo_categories.each do |geo_category_name, partner_categories|
          next if geo_category_name == 'is_chosen'
          selected_services[rouming_category_name.to_sym][service_category_name.to_sym][geo_category_name.to_sym] ||= {}
          selected_services[rouming_category_name.to_sym][service_category_name.to_sym][geo_category_name.to_sym][:is_chosen] = (partner_categories['is_chosen'] == 'true' ? true : false)
          partner_categories.each do |partner_category_name, partner_category|
            selected_services[rouming_category_name.to_sym][service_category_name.to_sym][geo_category_name.to_sym][partner_category_name.to_sym] = 
              if partner_category_name == 'is_chosen'
                (partner_category == 'true' ? true : false)
              else
                partner_category.blank? ? nil : partner_category
              end
          end
        end           
      end if service_categories
    end if selected_services
#    raise(StandardError)
    selected_services
  end  
  
  def self.service_categories_from_selected_services(selected_services = default_selected_categories)
    service_category_list = {}
    selected_services.each do |rouming_category_name, service_categories|
      next if service_categories and service_categories[:is_chosen] == false
      service_categories.each do |service_category_name, geo_categories|
        next if service_category_name == :is_chosen
        next if geo_categories and geo_categories[:is_chosen] == false
        if (geo_categories.keys - [:is_chosen]).blank?
          add_item_to_service_category_list(service_category_list, {:rouming => rouming_category_name, :service => service_category_name})
        else
          geo_categories.each do |geo_category_name, partner_categories|
            next if geo_category_name == :is_chosen
            next if partner_categories and partner_categories[:is_chosen] == false
            if partner_categories[:partner_category]
              add_item_to_service_category_list(service_category_list, 
                {:rouming => rouming_category_name, :service => service_category_name, :geo => geo_category_name, :partner => partner_categories[:partner_category]}  )
            else
              add_item_to_service_category_list(service_category_list, 
                {:rouming => rouming_category_name, :service => service_category_name, :geo => geo_category_name}  )
            end
          end          
        end
      end if service_categories
    end if selected_services
#    raise(StandardError)
    service_category_list
  end
  
  def self.add_item_to_service_category_list(service_category_list, category_names)
    part =  classify_service_category(category_names)
    service_category_key = build_service_category_key(category_names)
    service_category = build_service_category_by_category_names(category_names)
    
    service_category_list[part] ||= {}
    service_category_list[part][service_category_key] = service_category    
    service_category_list['mms'] ||= {}
    service_category_list['mms'][service_category_key] = service_category if part =~ /mms/
  end
  
  def self.build_service_category_key(category_names)
    category_names.map{|category_name| category_name[1].to_s if category_name[1] }.join('_') if category_names
  end
  
  def self.build_service_category_by_category_names(category_names)
    service_category = {}
    service_category[:service_category_rouming_id] = category_id_by_name(category_names[:rouming]) if category_names[:rouming]
    service_category[:service_category_calls_id] = category_id_by_name(category_names[:service]) if category_names[:service]
    service_category[:service_category_geo_id] = category_id_by_name(category_names[:geo]) if category_names[:geo]
    service_category[:service_category_partner_type_id] = category_id_by_name(category_names[:partner]) if category_names[:partner]
    service_category
  end

#TODO объединить с tarif_creator  
  def self.classify_service_category(category_names)
    [classify_service_category_rouming_part(category_names), classify_service_category_service_part(category_names)].join'/'
  end
  
  def self.classify_service_category_rouming_part(category_names)
    case category_names[:rouming]
    when :own_and_home_regions_rouming, :own_country_rouming
       'own-country-rouming'
    when :all_world_rouming
       'all-world-rouming'
    else
      raise(StandardError)
    end
  end

  def self.classify_service_category_service_part(category_names)
    case category_names[:service]
    when :calls_in, :calls_out
       'calls'
    when :sms_in, :sms_out
       'sms'
    when :mms_in, :mms_out
       'mms'
    when :internet
       'mobile-connection'
    else
      raise(StandardError)
    end
  end
 
  def self.category_id_by_name(name)
    case name
    when :own_and_home_regions_rouming; 21;
    when :own_country_rouming; 4; 
    when :all_world_rouming; 12; 
    when :calls_in; 302; 
    when :calls_out; 303; 
    when :sms_in; 311; 
    when :sms_out; 312; 
    when :mms_in; 321; 
    when :mms_out; 322; 
    when :internet; 340; 
    when :to_own_and_home_regions; 185; 
    when :to_own_country; 103; 
    when :to_not_own_country; 105; 
    when '230'; 230; #:service_to_beeline 
    when '231'; 231; #:service_to_megafon 
    when '232'; 232; #:service_to_mts
    when ''; nil
    else
      raise(StandardError)
      nil
    end
  end
    
  def self.default_selected_categories
    {
      :own_and_home_regions_rouming => {
        :is_chosen => true,
        :calls_in => {:is_chosen => true},
        :calls_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :sms_in => {:is_chosen => true},
        :sms_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :mms_in => {:is_chosen => true},
        :mms_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :internet => {:is_chosen => true},
      },
      :own_country_rouming => {
        :is_chosen => true,
        :calls_in => {:is_chosen => true},
        :calls_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :sms_in => {:is_chosen => true},
        :sms_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :mms_in => {:is_chosen => true},
        :mms_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :internet => {:is_chosen => true},
      },
      :all_world_rouming => {
        :is_chosen => true,
        :calls_in => {:is_chosen => true},
        :calls_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :sms_in => {:is_chosen => true},
        :sms_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :mms_in => {:is_chosen => true},
        :mms_out => {
          :is_chosen => true,
          :to_own_and_home_regions => {:is_chosen => true, :partner_category => nil}, 
          :to_own_country => {:is_chosen => true, :partner_category => nil}, 
          :to_not_own_country => {:is_chosen => true, :partner_category => nil}
          },
        :internet => {:is_chosen => true},
      }
    }
  end

end