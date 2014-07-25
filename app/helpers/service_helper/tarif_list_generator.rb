#TODO рассмотреть возможность добавить исключение опций из оптимизации по cost factor (цена на единицу объема выше определенного порога)
class ServiceHelper::TarifListGenerator  
  attr_reader :options, :operators, :tarifs, :common_services, :tarif_options             
  attr_accessor :all_services, :all_services_by_operator, :dependencies, :service_description, :uniq_parts_by_operator, :uniq_parts_criteria_by_operator, 
                :all_services_by_parts, :common_services_by_parts, :service_packs, :service_packs_by_parts,
                :service_packs_by_general_priority, :tarif_option_by_compatibility, :tarif_option_combinations, :tarif_sets_without_common_services, :tarif_sets, :final_tarif_sets                
  attr_accessor :tarif_options_slices, :tarif_options_count, :max_tarif_options_slice, :tarifs_slices, :tarifs_count, :max_tarifs_slice, :all_tarif_parts_count
  attr_reader :gp_tarif_option, :gp_tarif_without_limits, :gp_tarif_with_limits, :gp_tarif_option_with_limits, :gp_common_service, :use_short_tarif_set_name        
  
  def initialize(options = {} )
    @options = options
    @operators = (!options[:operators].blank? ? options[:operators] : [1025, 1028, 1030])
    @tarifs = (!options[:tarifs].blank? ? options[:tarifs] : {})
    ({1025 => [], 1028 => [], 1030 => [
        200, #202, 203, 204, 205,#_mts_red_energy, _mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_mts_connect_4
        #200, 201, 202, 203, 204, 205,#_mts_red_energy, _mts_smart, _mts_smart_mini, _mts_smart_plus, _mts_ultra, _mts_mts_connect_4
        #206, 207, 208, 210,# 209, #_mts_mayak, _mts_your_country, _mts_super_mts, _mts_umnyi_dom, _mts_super_mts_star
        ]} )
#    raise(StandardError, [@tarifs, !options[:tarifs].blank?, options] )
    @common_services = (!options[:common_services].blank? ? options[:common_services] : {})
    ({1025 => [], 1028 => [], 1030 => [
        #312,
        #276, 277, 312, # _mts_own_country_rouming, _mts_international_rouming, _mts_own_country_rouming_internet
        ]} )
    @tarif_options = (!options[:tarif_options].blank? ? options[:tarif_options] : {})
    ({1025 => [], 1028 => [], 1030 => [
        #283,
        #328, 329, 330, 331, 332,#_mts_region, _mts_95_cop_in_moscow_region, _mts_unlimited_calls, _mts_call_free_to_mts_russia_100, _mts_zero_to_mts, #calls
        #281, 309, #293, #_mts_love_country, _mts_love_country_all_world, _mts_outcoming_calls_from_11_9_rur, #calls_abroad
        #294, #282, 283, #297, #_mts_everywhere_as_home, _mts_everywhere_as_home_Ultra, _mts_everywhere_as_home_smart, _mts_incoming_travelling_in_russia, #country_rouming
        #321, 322, #_mts_additional_minutes_150, _mts_additional_minutes_300, #country_rouming
        #288, 289, 290, 291, 292, #_mts_zero_without_limits, _mts_bit_abroad, _mts_maxi_bit_abroad, _mts_super_bit_abroad, _mts_100mb_in_latvia_and_litva, #international_rouming
        #302, 303, 304, #_mts_bit, _mts_super_bit, _mts_mini_bit, #internet
        #310, 311, #_mts_additional_internet_500_mb, _mts_additional_internet_1_gb, #internet
        #313, 314, #_mts_turbo_button_500_mb, _mts_turbo_button_2_gb, #internet
        #315, 316, 317, 318, #_mts_internet_mini, _mts_internet_maxi, _mts_internet_super, _mts_internet_vip,#internet
        #340, 341, #_mts_mts_planshet, _mts_mts_planshet_online,#internet
        #342, #_mts_unlimited_internet_on_day,#internet
        #323, 324, 325, 326, #_mts_mms_packet_10, _mts_mms_packet_20, _mts_mms_packet_50, _mts_mms_discount_50_percent, #mms
        #280, #_mts_rodnye_goroda, #service_to_country
        #295, 296, #_mts_50_sms_travelling_in_russia, _mts_100_sms_travelling_in_russia,#sms
        #305, 306, 307, 308, #_mts_50_sms_in_europe, _mts_100_sms_in_europe, _mts_50_sms_travelling_in_all_world, _mts_100_sms_travelling_in_all_world,#sms
        #333, 334, 335, #_mts_onetime_sms_packet_50, _mts_onetime_sms_packet_150, _mts_onetime_sms_packet_300,#sms
        #336, 337, 338, 339, #_mts_monthly_sms_packet_100, _mts_monthly_sms_packet_300, _mts_monthly_sms_packet_500, _mts_monthly_sms_packet_1000,#sms        
      ]} )
    set_constant
    set_use_short_tarif_set_name
    check_input_from_options
#=begin
    calculate_all_services
    load_dependencies
    calculate_uniq_parts_by_operator
    calculate_all_services_by_parts
    calculate_common_services_by_parts
    calculate_service_packs
    calculate_service_packs_by_parts
    calculate_service_packs_by_general_priority
    calculate_tarif_option_by_compatibility
    calculate_tarif_option_combinations
    reorder_tarif_option_combinations
    calculate_tarif_option_combinations_with_multiple_use if true # на будущее
    calculate_tarif_sets_without_common_services
    @calculate_final_tarif_sets_first_without_common_services = false # проверить правильно ли исправил первый вариант когда in common_services есть новые parts 
    if @calculate_final_tarif_sets_first_without_common_services
      calculate_final_tarif_sets
      calculate_tarif_sets
      update_final_tarif_sets_with_common_services 
    else
      calculate_tarif_sets
      calculate_final_tarif_sets
    end
    calculate_tarif_options_slices
    calculate_max_tarif_options_slice
    calculate_tarifs_slices
    calculate_max_tarifs_slice
    calculate_all_tarif_parts_count    
    
#=end
  end
  
  def set_constant
    @gp_tarif_option = 320; @gp_tarif_without_limits = 321; @gp_tarif_with_limits = 322; @gp_tarif_option_with_limits =323; @gp_common_service = 324;    
  end
  
  def check_input_from_options
    @operators = [] if !operators or !operators.is_a?(Array)
    @tarifs = {} if !tarifs or !tarifs.is_a?(Hash)
    @common_services = {} if !common_services or !common_services.is_a?(Hash)
    @tarif_options = {} if !tarif_options or !tarif_options.is_a?(Hash)
    operators.each do |operator|
      @tarifs[operator] = [] if !tarifs or !tarifs[operator] or !tarifs[operator].is_a?(Array)
      @common_services[operator] = [] if !common_services or !common_services[operator] or !common_services[operator].is_a?(Array)
      @tarif_options[operator] = [] if !tarif_options or !tarif_options[operator] or !tarif_options[operator].is_a?(Array)
    end    
  end
  
  def set_use_short_tarif_set_name
    @use_short_tarif_set_name = options[:use_short_tarif_set_name] == 'true' ? true : false
  end
  
  def calculate_all_services
    @all_services = []; @all_services_by_operator = {}
    operators.each do |operator| 
      all_services_by_operator[operator] = tarifs[operator] + tarif_options[operator] + common_services[operator]
      @all_services +=  all_services_by_operator[operator]
    end
    all_services.uniq 
  end
  
  def load_dependencies
    @dependencies = {}; @service_description = {}
    TarifClass.where(:id => all_services).select("*").all.each do |r|
      service_description[r['id']] = r
      dependencies[r['id']] = r['dependency']
    end    
  end
  
  def calculate_uniq_parts_by_operator
    @uniq_parts_by_operator = {}; @uniq_parts_criteria_by_operator = {}
    all_services_by_operator.each do |operator, services|
      @uniq_parts_by_operator[operator] ||= []; @uniq_parts_criteria_by_operator[operator] ||= []
      services.each do |service|
#        raise(StandardError, dependencies[service] ) if service == 206 #!dependencies[service]['parts_criteria'] and dependencies[service]['parts']
        @uniq_parts_by_operator[operator] += dependencies[service]['parts']; @uniq_parts_criteria_by_operator[operator] += dependencies[service]['parts_criteria']
        @uniq_parts_by_operator[operator].uniq!; @uniq_parts_criteria_by_operator[operator].uniq!
      end
    end
  end
  
  def calculate_all_services_by_parts
    @all_services_by_parts = {}
    all_services_by_operator.each do |operator, services|
      all_services_by_parts[operator] = {}
      uniq_parts_by_operator[operator].each do |part|
        all_services_by_parts[operator][part] = []
      end
      
      services.each do |service|
        dependencies[service]['parts'].each do |part|
          all_services_by_parts[operator][part] << service
        end
      end      
    end
  end
  
  def calculate_common_services_by_parts
    @common_services_by_parts = {}
    common_services.each do |operator, services|
      common_services_by_parts[operator] = {}
      uniq_parts_by_operator[operator].each do |part|
        common_services_by_parts[operator][part] = []
      end
      
      services.each do |service|
        dependencies[service]['parts'].each do |part|
          common_services_by_parts[operator][part] << service
        end
      end      
    end
  end
  
  def calculate_service_packs
    @service_packs = {}
    operators.each do |operator| 
      tarifs[operator].each do |tarif|
        service_packs[tarif] = [tarif]
        common_services[operator].each {|common_service| service_packs[tarif] << common_service}
        tarif_options[operator].each do |tarif_option|
          if !dependencies[tarif_option]['prerequisites'].blank? and dependencies[tarif_option]['prerequisites'].include?(tarif)
            service_packs[tarif] << tarif_option
          end
          
          if !dependencies[tarif_option]['forbidden_tarifs']['to_switch_on'].blank? and !dependencies[tarif_option]['forbidden_tarifs']['to_switch_on'].include?(tarif)
            service_packs[tarif] << tarif_option
          end
          
          if dependencies[tarif_option]['prerequisites'].blank? and dependencies[tarif_option]['forbidden_tarifs']['to_switch_on'].blank?
            service_packs[tarif] << tarif_option
          end
        end
      end
    end
  end
  
  def calculate_service_packs_by_parts
    @service_packs_by_parts = {}
    service_packs.each do |tarif, service_pack|
      @service_packs_by_parts[tarif] ||= {}
      service_pack.each do |service|
        dependencies[service]['parts'].each do |part|
          @service_packs_by_parts[tarif][part] ||= []
          @service_packs_by_parts[tarif][part] << service
        end
      end
    end 
  end

  def calculate_service_packs_by_general_priority
    @service_packs_by_general_priority = {}
    service_packs_by_parts.each do |tarif, service_pack|
      service_packs_by_general_priority[tarif] ||= {}
      service_pack.each do |part, services|
        service_packs_by_general_priority[tarif][part] ||= {}
        services.each do |service|
          general_priority = dependencies[service]['general_priority']
          service_packs_by_general_priority[tarif][part][general_priority] ||= []
          service_packs_by_general_priority[tarif][part][general_priority] << service
        end
      end
    end
  end

  def calculate_tarif_option_by_compatibility
    @tarif_option_by_compatibility = {}
    service_packs_by_parts.each do |tarif, service_pack|
      tarif_option_by_compatibility[tarif] ||= {}
      service_pack.each do |part, services|
        tarif_option_by_compatibility[tarif][part] ||= {}
        services.each do |service|
          incompatibility_groups = dependencies[service]['incompatibility']
          incompatibility_groups.each do |incompatibility_name, incompatible_services|
            tarif_option_by_compatibility[tarif][part][incompatibility_name] ||= []
            tarif_option_by_compatibility[tarif][part][incompatibility_name] << service
          end
          
          operator = service_description[service][:operator_id].to_i
          if incompatibility_groups.blank? and !tarifs[operator].include?(service) and !common_services[operator].include?(service)
            tarif_option_by_compatibility[tarif][part][service] = [service]
          end
        end
        if tarif_option_by_compatibility[tarif][part].blank?
          tarif_option_by_compatibility[tarif][part] = {""=>[]}
        end
      end
    end
#    raise(StandardError, [tarif_option_by_compatibility ])
  end

  def calculate_tarif_option_combinations
    @tarif_option_combinations = {}
    tarif_option_by_compatibility.each do |tarif, service_pack|
      tarif_option_combinations[tarif] ||= {}
      service_pack.each do |part, incompatibility_groups|
        tarif_option_combinations[tarif][part] ||= {}

        incompatibility_groups.each do |incompatibility_group_name, incompatibility_group_1|
          incompatibility_group = incompatibility_group_1 + [nil]
          if tarif_option_combinations[tarif][part].blank?
            incompatibility_group.each do |service|
              tarif_set_id = tarif_set_id([service])
              tarif_option_combinations[tarif][part][tarif_set_id] = [service]
            end
          else
            current_tarif_option_combinations = tarif_option_combinations[tarif][part].dup
            current_tarif_option_combinations.each do |current_tarif_set_id, tarif_option_combination|
              incompatibility_group.each do |service|
                new_tarif_set = (tarif_option_combinations[tarif][part][current_tarif_set_id] + [service]).compact.uniq.sort
                new_tarif_set_id = tarif_set_id(new_tarif_set)
                tarif_option_combinations[tarif][part][new_tarif_set_id] = new_tarif_set
              end
            end
            incompatibility_group.each do |service|
              tarif_set_id = tarif_set_id([service])
              tarif_option_combinations[tarif][part][tarif_set_id] = [service]
            end
          end
        end        
      end
    end
  end

  def reorder_tarif_option_combinations
    unordered_tarif_option_combinations = tarif_option_combinations.dup
    @tarif_option_combinations = {}
    unordered_tarif_option_combinations.each do |tarif, service_pack|
      tarif_option_combinations[tarif] ||= {}
      service_pack.each do |part, tarif_sets|
        tarif_option_combinations[tarif][part] ||= {}
        tarif_sets.each do |tarif_set_id, services|
          tarif_option_group = []
          tarif_option_with_limit_group = []
          services.each do |service|
            next if service.blank?
            tarif_option_general_priority = dependencies[service]['general_priority']
            tarif_option_group << service if tarif_option_general_priority == gp_tarif_option
            tarif_option_with_limit_group << service if tarif_option_general_priority == gp_tarif_option_with_limits
            raise(StandardError, "tarif_option #{service} has wrong general_priority") if ![gp_tarif_option, gp_tarif_option_with_limits].include?(tarif_option_general_priority)
          end
          new_services = tarif_option_with_limit_group + tarif_option_group

          services.each do |service|
            next if service.blank?
            less_prioprite_tarif_options = new_services & dependencies[service]['other_tarif_priority']['lower']
            new_services = less_prioprite_tarif_options + (new_services - less_prioprite_tarif_options)

            more_prioprite_tarif_options = new_services & dependencies[service]['other_tarif_priority']['higher']
            new_services = (new_services - more_prioprite_tarif_options) + more_prioprite_tarif_options
          end
          new_tarif_set_id = tarif_set_id(new_services)
          tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
        end
      end
    end
  end

  def calculate_tarif_option_combinations_with_multiple_use
    ordered_tarif_option_combinations = tarif_option_combinations.dup
    @tarif_option_combinations = {}
    ordered_tarif_option_combinations.each do |tarif, service_pack|
      tarif_option_combinations[tarif] ||= {}
      service_pack.each do |part, tarif_sets|
        tarif_option_combinations[tarif][part] ||= {}
        tarif_sets.each do |tarif_set_id, services|
          new_services = []
          services.each do |service|
            next if service.blank?
            multiple_use = dependencies[service]['multiple_use']
            new_services << service
            break if multiple_use
          end
          new_tarif_set_id = tarif_set_id(new_services)
          tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
        end
      end
    end
  end 
  
  def calculate_tarif_sets_without_common_services
    @tarif_sets_without_common_services = {}
    operators.each do |operator|     
      tarifs[operator].each do |tarif|  
        operator = service_description[tarif][:operator_id].to_i
        tarif_sets_without_common_services[tarif] ||= {}
        dependencies[tarif]['parts'].each do |part|
          tarif_option_sets = tarif_option_combinations[tarif][part]
          tarif_sets_without_common_services[tarif][part] ||= {}
          tarif_general_priority = dependencies[tarif]['general_priority']

          if tarif_option_sets.blank?
            new_services = [tarif]
            new_tarif_set_id = tarif_set_id(new_services)
            tarif_sets_without_common_services[tarif][part][new_tarif_set_id] = new_services
          else
            tarif_option_sets.each do |tarif_set_id, tarif_options|
              new_services = [] #common_services_by_parts[operator][part]
              if tarif_general_priority == gp_tarif_without_limits
                new_services += [tarif] + tarif_options
              else
                tarif_option_group = []
                tarif_option_with_limit_group = []
                tarif_options.each do |tarif_option|
                  next if tarif_option.blank?
                  tarif_option_general_priority = dependencies[tarif_option]['general_priority']
                  tarif_option_group << tarif_option if tarif_option_general_priority == gp_tarif_option
                  tarif_option_with_limit_group << tarif_option if tarif_option_general_priority == gp_tarif_option_with_limits
                  
                  raise(StandardError, "tarif_option #{tarif_option} has wrong general_priority") if ![gp_tarif_option, gp_tarif_option_with_limits].include?(tarif_option_general_priority)
                  if !tarif_option_group.blank? and ( tarif_option_general_priority == gp_tarif_option_with_limits )
#TODO убрать                    raise(StandardError, "tarif_option #{tarif_option} has wrong general_priority #{tarif_option_group}  #{tarif_options}")                 
                  end
                  
                end
                new_services += tarif_option_with_limit_group + [tarif] + tarif_option_group
              end
              new_tarif_set_id = tarif_set_id(new_services)
              tarif_sets_without_common_services[tarif][part][new_tarif_set_id] = new_services
            end
          end
        end
      end
    end
  end
  
  def calculate_tarif_sets
    @tarif_sets = {}
    tarif_sets_without_common_services.each do |tarif, tarif_sets_without_common_services_by_tarif|
      operator = service_description[tarif][:operator_id].to_i
      tarif_sets[tarif] ||= {}
      tarif_sets_without_common_services_by_tarif.each do |part, tarif_sets_without_common_services_by_tarif_by_parts|
        tarif_sets[tarif][part] ||= {}
        tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
          services_with_common_services = (common_services_by_parts[operator][part] || []) + services
          services_with_common_services_id = tarif_set_id(services_with_common_services)
          tarif_sets[tarif][part][services_with_common_services_id] = services_with_common_services
        end
      end
      (common_services_by_parts[operator].keys - tarif_sets_without_common_services_by_tarif.keys).each do |part|
        tarif_sets[tarif][part] ||= {}
        tarif_set_id = tarif_set_id(common_services_by_parts[operator][part] || [])
        tarif_sets[tarif][part][tarif_set_id] = (common_services_by_parts[operator][part] || []) 
      end
    end
  end
  
  def calculate_final_tarif_sets
    @final_tarif_sets = {}
    operators.each do |operator|     
      tarifs[operator].each do |tarif|  
        operator = service_description[tarif][:operator_id].to_i
        current_uniq_service_sets = {}
        tarif_sets_to_calculate_from = @calculate_final_tarif_sets_first_without_common_services ? tarif_sets_without_common_services[tarif] : tarif_sets[tarif]
        tarif_sets_to_calculate_from.each do |part, tarif_sets_by_part|
          if current_uniq_service_sets.blank?
            tarif_sets_by_part.each do |tarif_set_by_part_id, services|
              current_uniq_service_sets[tarif_set_by_part_id] = {:service_ids => services, #:fobidden => false,
                :tarif_sets_by_part => [[part, tarif_set_by_part_id]], :fobidden_services => {part => tarif_sets_by_part.keys - [tarif_set_by_part_id]}}
            end 
          else            
            prev_uniq_service_sets = current_uniq_service_sets.clone
            current_uniq_service_sets = {}
            prev_uniq_service_sets.each do |uniq_service_set_id, uniq_service_set|
              tarif_sets_by_part.each do |tarif_set_by_part_id, services|
                new_uniq_services = services# - uniq_service_set[:service_ids] & services
                new_uniq_service_set_services = (uniq_service_set[:service_ids] + new_uniq_services)#.uniq.sort
                new_uniq_service_set_name = tarif_set_id(new_uniq_service_set_services)
                
                current_uniq_service_sets[new_uniq_service_set_name] ||= {}
                current_uniq_service_sets[new_uniq_service_set_name][:service_ids] = new_uniq_service_set_services
                current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] ||= []
#                current_uniq_service_sets[new_uniq_service_set_name][:fobidden] ||= uniq_service_set[:fobidden]
                current_uniq_service_sets[new_uniq_service_set_name][:fobidden_services] ||= {}
                current_uniq_service_sets[new_uniq_service_set_name][:fobidden_services][part] ||= []
                prev_uniq_service_sets[uniq_service_set_id][:fobidden_services].each do |forbidden_part, forbidden_service_set|
                  current_uniq_service_sets[new_uniq_service_set_name][:fobidden_services][forbidden_part] = forbidden_service_set
                end
                current_uniq_service_sets[new_uniq_service_set_name][:fobidden_services][part] = (
                  (current_uniq_service_sets[new_uniq_service_set_name][:fobidden_services][part] || []) + 
                  (prev_uniq_service_sets[uniq_service_set_id][:fobidden_services][part] || []) +
                  tarif_sets_by_part.keys - [tarif_set_by_part_id]
                ).uniq
                
                existing_tarif_sets_by_part = (current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] || [])                
                prev_tarif_sets_by_part = (prev_uniq_service_sets[uniq_service_set_id][:tarif_sets_by_part] || [])
                current_uniq_service_sets[new_uniq_service_set_name][:tarif_sets_by_part] = 
                  (existing_tarif_sets_by_part + prev_tarif_sets_by_part + [[part, tarif_set_by_part_id]]).uniq  
              end
            end
          end
        end
        
        current_uniq_service_sets.each do |uniq_service_set_id, uniq_service_set|
          tarif_sets_in_uniq_service_set = []
          tarif_sets_in_uniq_service_set_with_choice = []
          tarif_sets_in_uniq_service_set_with_no_choice = []
          accumulated_forbidden_sets = []
          accumulated_forbidden_sets_with_choice = []
          uniq_service_set[:fobidden] = false
          i = 0
          uniq_service_set[:tarif_sets_by_part].each do |uniq_service_set_item|
            part = uniq_service_set_item[0]
            common_services_to_exclude = (common_services_by_parts[operator][part] || [])
            current_tarif_set = uniq_service_set_item[1]
            current_tarif_set_without_common_services = current_tarif_set.split('_').map{|c| c.to_i} - common_services_to_exclude
            current_fobidden_services_without_common_services = uniq_service_set[:fobidden_services][part].collect{|f| f.split('_').map{|u| u.to_i} - common_services_to_exclude}
            condition_1 = (accumulated_forbidden_sets_with_choice - tarif_sets_in_uniq_service_set_with_no_choice).include?(current_tarif_set)
            condition_2 = !((tarif_sets_in_uniq_service_set_with_choice & current_fobidden_services_without_common_services).blank?)
            condition = (condition_1 or condition_2) #and condition_3

            raise(StandardError, [
              "part #{part}", 
              "current_tarif_set #{current_tarif_set}",
              "uniq_service_set[:fobidden_services][part] + [current_tarif_set] #{uniq_service_set[:fobidden_services][part] + [current_tarif_set]}", 
              "accumulated_forbidden_sets #{accumulated_forbidden_sets}", 
              "tarif_sets_in_uniq_service_set #{tarif_sets_in_uniq_service_set}", 
              "tarif_sets_in_uniq_service_set_with_choice #{tarif_sets_in_uniq_service_set_with_choice}",
              "condition_1 #{condition_1}", 
              "condition_2 #{condition_2}",
               "condition #{condition}",
              "uniq_service_set[:tarif_sets_by_part] #{uniq_service_set[:tarif_sets_by_part]}"
              ].join("\n")) if uniq_service_set[:tarif_sets_by_part].map{|u| u[1] }.include?('200') and
              i == 111 and uniq_service_set_id == '277_200_276_200_200_200_312_200_302_276_200_200_200_277_277'
            
            uniq_service_set[:fobidden] = true if condition
            next if condition
            accumulated_forbidden_sets = (accumulated_forbidden_sets + current_fobidden_services_without_common_services).uniq
            accumulated_forbidden_sets_with_choice = (accumulated_forbidden_sets + current_fobidden_services_without_common_services).uniq if !current_fobidden_services_without_common_services.blank?
            tarif_sets_in_uniq_service_set = (tarif_sets_in_uniq_service_set + [current_tarif_set_without_common_services]).uniq
            tarif_sets_in_uniq_service_set_with_choice = (tarif_sets_in_uniq_service_set_with_choice + [current_tarif_set_without_common_services]).uniq if !current_fobidden_services_without_common_services.blank?
            tarif_sets_in_uniq_service_set_with_no_choice = (tarif_sets_in_uniq_service_set_with_no_choice + [current_tarif_set_without_common_services]).uniq if current_fobidden_services_without_common_services.blank?
            i += 1
          end

#          condition_2 = !((tarif_sets_in_uniq_service_set_with_choice & uniq_service_set[:fobidden_services][part]).blank?)
#          condition = (condition_2) #and condition_3
#          uniq_service_set[:fobidden] = true if condition


          if use_short_tarif_set_name
            short_service_set_id = tarif_set_id(uniq_service_set[:service_ids].uniq)
          else
            short_service_set_id = uniq_service_set_id
          end          
          if !uniq_service_set[:fobidden]
#TODO разобраться какие наборы тарифов дублируются с короткими номерами и что с этим делать            
            raise(StandardError, ["final_tarif_sets with key #{short_service_set_id} already exist", 
              uniq_service_set[:fobidden], uniq_service_set_id, 
              final_tarif_sets[short_service_set_id][:full_set_name]]) if (final_tarif_sets[short_service_set_id] and (uniq_service_set_id != final_tarif_sets[short_service_set_id][:full_set_name]))
            final_tarif_sets[short_service_set_id] = uniq_service_set.merge(:full_set_name => uniq_service_set_id) 
          end
        end
#        final_tarif_sets.merge!(current_uniq_service_sets)
      end
    end
  end
  
  def update_final_tarif_sets_with_common_services
    dup_final_tarif_sets = final_tarif_sets.clone
    @final_tarif_sets = {}
    dup_final_tarif_sets.each do |final_tarif_set_id, final_tarif_set|
      operator = service_description[final_tarif_set_id.split('_')[0].to_i][:operator_id].to_i      
      common_services_to_add = (common_services[operator] || [])
      final_tarif_set_services_with_common_services = common_services_to_add + final_tarif_set[:service_ids] 
      if use_short_tarif_set_name
        final_tarif_set_id_with_common_services = tarif_set_id(final_tarif_set_services_with_common_services.uniq)
      else
        final_tarif_set_id_with_common_services = tarif_set_id(final_tarif_set_services_with_common_services)
      end      

      final_tarif_sets[final_tarif_set_id_with_common_services] ||= {}
      final_tarif_sets[final_tarif_set_id_with_common_services][:service_ids] = final_tarif_set_services_with_common_services
      final_tarif_sets[final_tarif_set_id_with_common_services][:fobidden] = final_tarif_set[:fobidden]
      final_tarif_sets[final_tarif_set_id_with_common_services][:fobidden_services] = final_tarif_set[:fobidden_services]

      final_tarif_set[:tarif_sets_by_part].each do |tarif_sets_by_part|
        final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] ||= []
        part = tarif_sets_by_part[0]
        common_services_by_part_to_add = (common_services_by_parts[operator][part] || [])
        tarif_sets_by_part_with_common_services = common_services_by_part_to_add + tarif_sets_by_part[1].split('_')
        tarif_sets_by_part_with_common_services_id = tarif_set_id(tarif_sets_by_part_with_common_services)
      
        final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] <<
          [part, tarif_sets_by_part_with_common_services_id] 
      end if final_tarif_set[:tarif_sets_by_part]
      
      parts_from_tarif_sets_by_part = final_tarif_set[:tarif_sets_by_part].collect{|tarif_sets_by_part| tarif_sets_by_part[0]}
      (common_services_by_parts[operator].keys - parts_from_tarif_sets_by_part).each do |part|

        tarif_sets_by_part_with_common_services = (common_services_by_parts[operator][part] || [])
        tarif_sets_by_part_with_common_services_id = tarif_set_id(tarif_sets_by_part_with_common_services)
      
        final_tarif_sets[final_tarif_set_id_with_common_services][:tarif_sets_by_part] <<
          [part, tarif_sets_by_part_with_common_services_id] 
      end
    end
  end

  def calculate_tarif_options_slices
    @tarif_options_slices = {}
    tarif_option_combinations.each do |tarif, service_pack|
      operator = service_description[tarif][:operator_id].to_i
      tarif_options_slices[operator] ||= []
      service_pack.each do |part, tarif_option_sets|
        tarif_option_sets.each do |tarif_set_id, tarif_options|
          slice = 0
          tarif_options.reverse.each do |tarif_option|
            next if tarif_option.blank?
            tarif_options_slices[operator][slice] ||= {:ids => [], :prev_ids => [], :set_ids => [], :prev_set_ids => [], :uniq_set_ids => {}, :parts => []}
            tarif_option_general_priority = dependencies[tarif_option]['general_priority']
            if tarif_option_general_priority == gp_tarif_option
              set_ids = tarif_options.reverse[0..slice].reverse
              set_id = tarif_set_id(set_ids)
              uniq_set_id = tarif_set_id_with_part(set_ids, part)
              if !tarif_options_slices[operator][slice][:uniq_set_ids][uniq_set_id]
                tarif_options_slices[operator][slice][:uniq_set_ids][uniq_set_id] = uniq_set_id
                
                prev_ids = (slice == 0) ? [] : tarif_options.reverse[0..(slice - 1)].reverse
                tarif_options_slices[operator][slice][:prev_ids] << prev_ids
                tarif_options_slices[operator][slice][:ids] << tarif_option
                tarif_options_slices[operator][slice][:prev_set_ids] << tarif_set_id(prev_ids)
                tarif_options_slices[operator][slice][:set_ids] << set_id 
                tarif_options_slices[operator][slice][:parts] << part 
              end
            end
            slice += 1
          end          
        end        
      end
    end
  end
  
  def calculate_tarifs_slices
    @tarifs_slices = {}
    tarif_sets.each do |tarif, service_pack|
      operator = service_description[tarif][:operator_id].to_i
      tarifs_slices[operator] ||= []
      service_pack.each do |part, tarif_sets|
        tarif_sets.each do |tarif_set_id, services|
#          raise(StandardError, [service_pack]) if tarif == 203 #tarif_set_id == "203_283"  and part == 'own-country-rouming/sms'
          slice = 0; tarif_option_slice = 0
          services.reverse.each do |service|
            next if service.blank?
            tarifs_slices[operator][slice] ||= {:ids => [], :prev_ids => [], :set_ids => [], :prev_set_ids => [], :uniq_set_ids => {}, :parts => []}
            service_general_priority = dependencies[service]['general_priority']

            if service_general_priority == gp_tarif_option
              tarif_option_slice += 1
#TODO              
              raise(StandardError, ["Wrong service order #{service} in tarif #{tarif}", services, slice]) if slice > 0
            else
              current_service_index = slice + tarif_option_slice
              if slice == 0 
            raise(StandardError, [part, tarif_set_id, service, 
              services, slice, tarif_option_slice, service_general_priority == gp_tarif_option]) if tarif_set_id == "276_203_283"  and part == 'own-country-rouming/calls_' and service == 276

                if tarif_option_slice == 0
                  set_ids = services.reverse[0..tarif_option_slice].reverse
                  set_id = tarif_set_id(set_ids)
                  prev_ids = []
                  uniq_set_id = tarif_set_id_with_part(set_ids, part)
                else
                  set_ids = services.reverse[0..tarif_option_slice].reverse
#                  set_ids = [service] + services.reverse[0..tarif_option_slice].reverse
                  set_id = tarif_set_id(set_ids)
                  prev_ids = services.reverse[0..(current_service_index - 1)].reverse
  #                prev_ids = (tarif_option_slice == 0) ? [] : services.reverse[0..(tarif_option_slice - 1)].reverse
                  uniq_set_id = tarif_set_id_with_part(set_ids, part)
                end
                if !tarifs_slices[operator][slice][:uniq_set_ids][uniq_set_id] 
                  tarifs_slices[operator][slice][:uniq_set_ids][uniq_set_id] = uniq_set_id
                  tarifs_slices[operator][slice][:prev_ids] << prev_ids
                  tarifs_slices[operator][slice][:ids] << service
                  tarifs_slices[operator][slice][:prev_set_ids] << tarif_set_id(prev_ids)
                  tarifs_slices[operator][slice][:set_ids] << set_id 
                  tarifs_slices[operator][slice][:parts] << part 
            raise(StandardError, [part, uniq_set_id, set_ids, service, 
              services, slice, tarif_option_slice, set_ids, prev_ids]) if tarif_set_id == "276_203_283"  and part == 'own-country-rouming/calls_'
                end
              else #if tarif_option_slice != 0
                set_ids = services.reverse[0..(current_service_index )].reverse
                set_id = tarif_set_id(set_ids)
                uniq_set_id = tarif_set_id_with_part(set_ids, part)
                if !tarifs_slices[operator][slice][:uniq_set_ids][uniq_set_id]
                  tarifs_slices[operator][slice][:uniq_set_ids][uniq_set_id] = uniq_set_id
                  prev_ids = (current_service_index == 0) ? [] : services.reverse[0..(current_service_index - 1)].reverse
                  tarifs_slices[operator][slice][:prev_ids] << prev_ids
                  tarifs_slices[operator][slice][:ids] << service
                  tarifs_slices[operator][slice][:prev_set_ids] << tarif_set_id(prev_ids)
                  tarifs_slices[operator][slice][:set_ids] << set_id 
                  tarifs_slices[operator][slice][:parts] << part 
              raise(StandardError, [part, uniq_set_id, set_ids, service, current_service_index, (tarif_option_slice + slice),
                services, slice, tarif_option_slice]) if tarif_set_id == "276_203_283"  and part == 'own-country-rouming/calls_'
                end
              end  
              raise(StandardError, [part, uniq_set_id, set_ids, service, 
                services, slice, tarif_option_slice]) if tarif_set_id == "276_203_283"  and part == 'own-country-rouming/calls_'
              #tarif_option_slice = 0
              slice += 1            
            end
          end
        end  
      end
    end
  end
  
  def calculate_max_tarif_options_slice
    @max_tarif_options_slice = {}; @tarif_options_count = {}
    operators.each do |operator| 
      tarif_options_count[operator] = 0
      if tarif_options_slices[operator]
        max_tarif_options_slice[operator] = tarif_options_slices[operator].size
        tarif_options_slices[operator].each_index do |slice|
          tarif_options_count[operator] += tarif_options_slices[operator][slice][:uniq_set_ids].size
        end         
      else
        max_tarif_options_slice[operator] = 0
      end
    end
  end
  
  def calculate_max_tarifs_slice
    @max_tarifs_slice = {}; @tarifs_count = {}
    operators.each do |operator| 
      tarifs_count[operator] = 0
      if tarifs_slices[operator]
        max_tarifs_slice[operator] = tarifs_slices[operator].size
        tarifs_slices[operator].each_index do |slice|
          tarifs_count[operator] += tarifs_slices[operator][slice][:uniq_set_ids].size
        end         
      else
        max_tarifs_slice[operator] = 0
      end
    end
  end
  
  def calculate_all_tarif_parts_count
    @all_tarif_parts_count = {}
    operators.each do |operator|
      all_tarif_parts_count[operator] = 0
      [tarif_options_slices[operator], tarifs_slices[operator]].each do |service_slices|
        service_slices.each do |service_slice|
          all_tarif_parts_count[operator] += (service_slice[:ids].size * (service_slice[:set_ids][0].split('_').size + 1 ) ) if service_slice[:set_ids] and service_slice[:set_ids][0] 
        end if service_slices
      end 
    end
  end  
  
  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end

  def tarif_set_id_with_part(tarif_ids, part)
    tarif_ids.collect {|tarif_id| "#{tarif_id}::#{part}" if tarif_id}.compact.join('_')
  end

end
