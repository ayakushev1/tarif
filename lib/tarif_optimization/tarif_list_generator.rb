#TODO рассмотреть возможность добавить исключение опций из оптимизации по cost factor (цена на единицу объема выше определенного порога)
class TarifOptimization::TarifListGenerator  
  attr_reader :options, :operators, :tarifs, :common_services, :tarif_options             
  attr_accessor :all_services, :all_services_by_operator, :dependencies, :service_description, :uniq_parts_by_operator, :uniq_parts_criteria_by_operator, 
                :all_services_by_parts, :common_services_by_parts, :service_packs, :service_packs_by_parts, :services_that_depended_on, :periodic_services, :onetime_services,
                :service_packs_by_general_priority, :tarif_option_by_compatibility, :fobidden_combinations_by_service, :parts_by_service,
                :tarif_option_combinations, :tarif_sets_without_common_services, :tarif_sets                
  
  attr_accessor :tarif_options_slices, :tarif_options_count, :max_tarif_options_slice, :tarifs_slices, :tarifs_count, :max_tarifs_slice, :all_tarif_parts_count
  
  attr_reader :gp_tarif_option, :gp_tarif_without_limits, :gp_tarif_with_limits, :gp_tarif_option_with_limits, :gp_common_service, :all_parts,
              :parts_used_as_multiple
         
  attr_reader :calculate_with_multiple_use, :calculate_only_chosen_services, :calculate_with_fixed_services
             
  
  def initialize(options = {} )
    @options = options
    set_operators_and_services(options)
#    raise(StandardError)
    set_constant
    set_parts
    set_generation_params(options)
    check_input_from_options
    calculate_all_services
    load_dependencies
    load_services_that_depended_on
    load_periodic_services
    calculate_uniq_parts_by_operator
    calculate_parts_by_service
    calculate_all_services_by_parts
    calculate_common_services_by_parts
  end
  
  def set_operators_and_services(options)
    @operators = (!options[:services_by_operator][:operators].blank? ? options[:services_by_operator][:operators] : [1023, 1025, 1028, 1030])
    @tarifs = {1023 => [], 1025 => [], 1028 => [], 1030 => []}
    @common_services = {1023 => [], 1025 => [], 1028 => [], 1030 => []}
    @tarif_options = {1023 => [], 1025 => [], 1028 => [], 1030 => []}
    operators.each do |operator|
      tarifs[operator] = options[:services_by_operator][:tarifs][operator] if options and options[:services_by_operator][:tarifs] and options[:services_by_operator][:tarifs][operator]  
      common_services[operator] = options[:services_by_operator][:common_services][operator] if options and options[:services_by_operator][:common_services] and options[:services_by_operator][:common_services][operator]  
      tarif_options[operator] = options[:services_by_operator][:tarif_options][operator] if options and options[:services_by_operator][:tarif_options] and options[:services_by_operator][:tarif_options][operator]  
    end if operators
    all_tarifs_count = tarifs.map{|operator, tarif_by_operator| tarif_by_operator.size }.sum
    if all_tarifs_count == 0
      default_tarifs = {1023 => [], 1025 => [], 1028 => [100], 1030 => [200]}
      operators.each do |operator|
        tarifs[operator] = default_tarifs[operator]
      end
    end
  end
  
  def calculate_tarif_sets_and_slices(operator = nil, tarif =nil)
#=begin
    calculate_service_packs(operator, tarif)
    calculate_service_packs_by_parts
    calculate_service_packs_by_general_priority
    calculate_tarif_option_by_compatibility
    calculate_tarif_option_combinations
    reorder_tarif_option_combinations
    calculate_tarif_option_combinations_with_multiple_use if true # на будущее
    calculate_tarif_sets_without_common_services(operator, tarif)
    calculate_tarif_sets
##    calculate_final_tarif_sets
    calculate_tarif_options_slices
    calculate_max_tarif_options_slice(operator, tarif)
    calculate_tarifs_slices
    calculate_max_tarifs_slice(operator, tarif)
    calculate_all_tarif_parts_count(operator, tarif) 
    
#=end
  end
  
  def set_constant
    @gp_tarif_option = 320; @gp_tarif_without_limits = 321; @gp_tarif_with_limits = 322; @gp_tarif_option_with_limits =323; @gp_common_service = 324;    
  end
  
  def set_parts(parts = nil)
    if parts
      @all_parts = parts
    else
      @all_parts = [
        'all-world-rouming/sms', 'all-world-rouming/mms', 'all-world-rouming/calls', 'all-world-rouming/mobile-connection',
        'own-country-rouming/sms', 'own-country-rouming/mms', 'own-country-rouming/calls', 'own-country-rouming/mobile-connection', 
        'mms', 'onetime', 'periodic'
        ]
    end
    @parts_used_as_multiple = ['all-world-rouming/sms', 'own-country-rouming/sms', 'all-world-rouming/mms', 'mms', 'own-country-rouming/mms', 
      'all-world-rouming/mobile-connection', 'own-country-rouming/mobile-connection' ] & @all_parts
  end
  
  def set_generation_params(options)
    @calculate_with_multiple_use = options[:tarif_list_generator_params][:calculate_with_multiple_use] == 'true' ? true : false
    @calculate_only_chosen_services = options[:tarif_list_generator_params][:calculate_only_chosen_services] == 'true' ? true : false
    @calculate_with_fixed_services = options[:tarif_list_generator_params][:calculate_with_fixed_services] == 'true' ? true : false
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
  
  def load_services_that_depended_on
    @services_that_depended_on = {}
#TODO добавить индекс на (conditions->>'tarif_set_must_include_tarif_options')
#TODO можно сразу выбирать уникальные значения сервисов
    Service::CategoryTarifClass.where(:tarif_class_id => all_services).where("(conditions->>'tarif_set_must_include_tarif_options') is not null").
      select("tarif_class_id, conditions->>'tarif_set_must_include_tarif_options' as tarif_set_must_include_tarif_options").uniq.each do |r|
        dependent_services = eval(r['tarif_set_must_include_tarif_options'])
        tarif_class_id = r['tarif_class_id'].to_i
        @services_that_depended_on[tarif_class_id] ||= []
        @services_that_depended_on[tarif_class_id] += ((dependent_services & all_services) - @services_that_depended_on[tarif_class_id])
    end    
  end
  
  def load_periodic_services
    @periodic_services = [], @onetime_services = []
    Service::CategoryTarifClass.where(:tarif_class_id => all_services).where.not(:service_category_periodic_id => nil).select(:tarif_class_id).uniq.each do |r|
        tarif_class_id = r['tarif_class_id'].to_i
        @periodic_services << tarif_class_id
    end    
    Service::CategoryTarifClass.where(:tarif_class_id => all_services).where.not(:service_category_one_time_id => nil).select(:tarif_class_id).uniq.each do |r|
        tarif_class_id = r['tarif_class_id'].to_i
        @onetime_services << tarif_class_id
    end    
  end
  
  def calculate_uniq_parts_by_operator
    @uniq_parts_by_operator = {}; @uniq_parts_criteria_by_operator = {}
    all_services_by_operator.each do |operator, services|
      @uniq_parts_by_operator[operator] ||= []; @uniq_parts_criteria_by_operator[operator] ||= []
      services.each do |service|
#TODO убрать дублирование по parts_criteria в calls_stat_calculator
        @uniq_parts_by_operator[operator] += ((dependencies[service] || {})['parts'] & all_parts) - @uniq_parts_by_operator[operator]; 
        @uniq_parts_criteria_by_operator[operator] += (dependencies[service] || {})['parts_criteria'] - @uniq_parts_criteria_by_operator[operator]
      end
    end
  end
  
  def calculate_parts_by_service
    @parts_by_service = {}
    all_services_by_operator.each do |operator, services|
      services.each do |service|
        parts_by_service[service] = []
        (dependencies[service]['parts'] & all_parts).each do |part|
          parts_by_service[service] << part 
        end
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
        (dependencies[service]['parts'] & all_parts).each do |part|
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
      end if uniq_parts_by_operator and uniq_parts_by_operator[operator] 
      
      services.each do |service|
        (dependencies[service]['parts'] & all_parts).each do |part|
          common_services_by_parts[operator][part] << service
        end
      end      
    end
  end
  
  def calculate_service_packs(operator_1 = nil, tarif_1 = nil)
    @service_packs = {}
    (operator_1 ? [operator_1] : operators).each do |operator| 
      (tarif_1 ? [tarif_1] : tarifs[operator]).each do |tarif|
        service_packs[tarif] = [tarif]
        common_services[operator].each {|common_service| service_packs[tarif] << common_service}
        tarif_options[operator].each do |tarif_option|
          next if dependencies[tarif_option]['is_archived'] == true

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
#    raise(StandardError)
    @service_packs_by_parts = {}
    service_packs.each do |tarif, service_pack|
      @service_packs_by_parts[tarif] ||= {}
      service_pack.each do |service|
        (dependencies[service]['parts'] & all_parts).each do |part|
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
#TODO Разобраться что делать когда одна опция несовместима с двумя другими, которые между собой совместимы    
    @tarif_option_by_compatibility = {}
    @fobidden_combinations_by_service = {}
    if calculate_only_chosen_services or calculate_with_fixed_services
      service_packs_by_parts.each do |tarif, service_pack|
        tarif_option_by_compatibility[tarif] ||= {}
        service_pack.each do |part, services|
          tarif_option_by_compatibility[tarif][part] ||= {}
          services.each do |service|
            incompatibility_name = service.to_s
            tarif_option_by_compatibility[tarif][part][incompatibility_name] = [service]
          end

#      raise(StandardError, @tarif_option_by_compatibility)
          if tarif_option_by_compatibility[tarif][part].blank?
            tarif_option_by_compatibility[tarif][part] = {""=>[]}
          end
        end
      end
    else
      service_packs_by_parts.each do |tarif, service_pack|
        tarif_option_by_compatibility[tarif] ||= {}
        fobidden_combinations_by_service[tarif] ||= {}
        service_pack.each do |part, services|
          tarif_option_by_compatibility[tarif][part] ||= {}
          fobidden_combinations_by_service[tarif][part] ||= {}
          if ['periodic', 'onetime'].include?(part)
            periodic_incompatibility_name = 'special_periodic_for_tarif_list_generation'
            tarif_option_by_compatibility[tarif][part][periodic_incompatibility_name] = services
          else
            services.each do |service|
              fobidden_combinations_by_service[tarif][part][service] ||= []
              incompatibility_groups = dependencies[service]['incompatibility']
              incompatibility_groups.each do |incompatibility_name, incompatible_services|
                tarif_option_by_compatibility[tarif][part][incompatibility_name] ||= []
                tarif_option_by_compatibility[tarif][part][incompatibility_name] << service
                fobidden_combinations_by_service[tarif][part][service] = fobidden_combinations_by_service[tarif][part][service] + incompatible_services
                fobidden_combinations_by_service[tarif][part][service].uniq!
              end
              
              operator = service_description[service][:operator_id].to_i
              if incompatibility_groups.blank? and !tarifs[operator].include?(service) and !common_services[operator].include?(service)
#    raise(StandardError) if part == 'all-world-rouming/calls' and service == 405
                tarif_option_by_compatibility[tarif][part][service] = [service]
              end
            end
          end
          if tarif_option_by_compatibility[tarif][part].blank?
            tarif_option_by_compatibility[tarif][part] = {""=>[]}
          end
        end
      end
    end
#    raise(StandardError, [tarif_option_by_compatibility ])
  end

  def calculate_tarif_option_combinations
    @tarif_option_combinations = {}
    fobidden_combinations_by_set_id = {}
    if calculate_only_chosen_services or calculate_with_fixed_services
      tarif_option_by_compatibility.each do |tarif, service_pack|
        tarif_option_combinations[tarif] ||= {}
        service_pack.each do |part, incompatibility_groups|
          next if ['periodic', 'onetime'].include?(part)
          tarif_option_combinations[tarif][part] ||= {}
          services = incompatibility_groups.values.flatten.uniq
          tarif_set_id = tarif_set_id(services)
          tarif_option_combinations[tarif][part][tarif_set_id] = services
        end
        
        uniq_services_in_tarif_option_combinations = tarif_option_combinations[tarif].map{|c| c[1].map{|t| t[1]}}.flatten.compact.uniq
        (uniq_services_in_tarif_option_combinations & periodic_services).each do |service|
          tarif_option_combinations[tarif]['periodic'] ||= {}
          tarif_option_combinations[tarif]['periodic'][tarif_set_id([service])] = [service]
        end
        (uniq_services_in_tarif_option_combinations & onetime_services).each do |service|
           tarif_option_combinations[tarif]['onetime'] ||= {}
         tarif_option_combinations[tarif]['onetime'][tarif_set_id([service])] = [service]
        end
      end
    else      
      tarif_option_by_compatibility.each do |tarif, service_pack|
        tarif_option_combinations[tarif] ||= {}
        fobidden_combinations_by_set_id[tarif] = {}
        service_pack.each do |part, incompatibility_groups|
          tarif_option_combinations[tarif][part] ||= {}
          fobidden_combinations_by_set_id[tarif][part] ||= {}
          if ['periodic', 'onetime'].include?(part)
            incompatibility_groups['special_periodic_for_tarif_list_generation'].each do |service|
              tarif_set_id = tarif_set_id([service])
              tarif_option_combinations[tarif][part][tarif_set_id] = [service]
            end if incompatibility_groups['special_periodic_for_tarif_list_generation']
          else
#            raise(StandardError)
            incompatibility_groups.each do |incompatibility_group_name, incompatibility_group_1|
              incompatibility_group = incompatibility_group_1 + [nil]
              if tarif_option_combinations[tarif][part].blank?
                incompatibility_group.each do |service|
                  tarif_set_id = tarif_set_id([service])
                  tarif_option_combinations[tarif][part][tarif_set_id] = [service]
                  
                  fobidden_combinations_by_set_id[tarif][part][tarif_set_id] = fobidden_combinations_by_service[tarif][part][service] || []
                end
              else
                current_tarif_option_combinations = tarif_option_combinations[tarif][part].dup
                current_tarif_option_combinations.each do |current_tarif_set_id, tarif_option_combination|
                  incompatibility_group.each do |service|
                    if !fobidden_combinations_by_set_id[tarif][part][current_tarif_set_id].include?(service)                      
                      new_tarif_set = (tarif_option_combinations[tarif][part][current_tarif_set_id] + [service]).compact.uniq.sort
                      new_tarif_set_id = tarif_set_id(new_tarif_set)
                      tarif_option_combinations[tarif][part][new_tarif_set_id] = new_tarif_set
                      
                       
                      fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id] = (fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id] || []) + 
                        fobidden_combinations_by_set_id[tarif][part][current_tarif_set_id] + (fobidden_combinations_by_service[tarif][part][service] || [])
                      fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id].uniq!  
                    end 
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
        uniq_services_in_tarif_option_combinations = tarif_option_combinations[tarif].map{|c| c[1].map{|t| t[1]}}.flatten.compact.uniq
        (uniq_services_in_tarif_option_combinations & periodic_services).each do |service|
          tarif_option_combinations[tarif]['periodic'][tarif_set_id([service])] = [service]
        end
        (uniq_services_in_tarif_option_combinations & onetime_services).each do |service|
          tarif_option_combinations[tarif]['onetime'][tarif_set_id([service])] = [service]
        end
      end
    end
#    raise(StandardError)
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
          if ['periodic', 'onetime'].include?(part)
            tarif_option_combinations[tarif][part][tarif_set_id] = services
          else
            services.each do |service|
              next if service.blank?
              tarif_option_general_priority = dependencies[service]['general_priority']
              tarif_option_group << service if tarif_option_general_priority == gp_tarif_option
              tarif_option_with_limit_group << service if tarif_option_general_priority == gp_tarif_option_with_limits
              if !calculate_only_chosen_services or !calculate_with_fixed_services
#TODO вернуть когда добавлю вывод ошибок в фоновом режиме вычислений
                raise(StandardError, "tarif_option #{service} has wrong general_priority") if false #![gp_tarif_option, gp_tarif_option_with_limits].include?(tarif_option_general_priority)
              end
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
#    raise(StandardError)
  end

  def calculate_tarif_option_combinations_with_multiple_use
    ordered_tarif_option_combinations = tarif_option_combinations.dup
    @tarif_option_combinations = {}
    ordered_tarif_option_combinations.each do |tarif, service_pack|
      tarif_option_combinations[tarif] ||= {}
      service_pack.each do |part, tarif_sets|
#        next if part == 'periodic'
        tarif_option_combinations[tarif][part] ||= {}
        tarif_sets.each do |tarif_set_id, services|
          new_services = []
          services.each do |service|
            next if service.blank?
            multiple_use = dependencies[service]['multiple_use']
            new_services << service
#TODO разобраться когда можно использовать multiple_use (для каких parts), и связать с параметрами оптимизации 
            break if false #calculate_with_multiple_use and multiple_use and parts_used_as_multiple.include?(part)
          end
          new_tarif_set_id = tarif_set_id(new_services)
          tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
        end
      end
    end
#    raise(StandardError)
  end 
  
  def calculate_tarif_sets_without_common_services(operator_1 = nil, tarif_1 = nil)
    @tarif_sets_without_common_services = {}
    (operator_1 ? [operator_1] : operators).each do |operator|     
      (tarif_1 ? [tarif_1] : tarifs[operator]).each do |tarif|  
        operator = service_description[tarif][:operator_id].to_i
        tarif_sets_without_common_services[tarif] ||= {}
        all_parts.each do |part|
          next if ['periodic', 'onetime'].include?(part)
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
                  
#                  raise(StandardError, "tarif_option #{tarif_option} has wrong general_priority") if false#![gp_tarif_option, gp_tarif_option_with_limits].include?(tarif_option_general_priority)
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
        
        services_that_depended_on_service_ids = services_that_depended_on.keys.map(&:to_i) 
        tarif_sets_without_common_services[tarif]['periodic'] ||= {}
        tarif_sets_without_common_services[tarif]['onetime'] ||= {}
        
        tarif_sets_without_common_services[tarif].each do |part, tarif_sets_without_common_services_by_part|    
          next if ['periodic', 'onetime'].include?(part)      
          tarif_sets_without_common_services_by_part.each do |tarif_set_id, services|
#            (services_that_depended_on_service_ids & services & periodic_services).each do |main_depended_service|
            (services_that_depended_on_service_ids & services).each do |main_depended_service|
              new_periodic_services = [main_depended_service] + services_that_depended_on[main_depended_service]
              new_tarif_set_id = tarif_set_id(new_periodic_services)
              tarif_sets_without_common_services[tarif]['periodic'][new_tarif_set_id] = new_periodic_services
            end
#            (services_that_depended_on_service_ids & services & onetime_services).each do |main_depended_service|
            (services_that_depended_on_service_ids & services).each do |main_depended_service|
              new_periodic_services = [main_depended_service] + services_that_depended_on[main_depended_service]
              new_tarif_set_id = tarif_set_id(new_periodic_services)
              tarif_sets_without_common_services[tarif]['onetime'][new_tarif_set_id] = new_periodic_services
            end
          end
        end
        
        ((tarif_option_combinations[tarif]['periodic'].map{|o| o[1]}.flatten + [tarif])).each do |service|
          tarif_sets_without_common_services[tarif]['periodic'][tarif_set_id([service])] = [service]
        end if tarif_option_combinations[tarif]['periodic']
        
        ((tarif_option_combinations[tarif]['onetime'].map{|o| o[1]}.flatten + [tarif])).each do |service|
          tarif_sets_without_common_services[tarif]['onetime'][tarif_set_id([service])] = [service]
        end if tarif_option_combinations[tarif]['onetime']
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
        
        allowed_common_services = check_allowed_common_services(common_services_by_parts[operator][part] || [], tarif)
        
        if ['periodic', 'onetime'].include?(part)
          tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
            tarif_sets[tarif][part][tarif_set_id] = services            
          end
          
          allowed_common_services.each do |common_service|
            common_services_id = tarif_set_id([common_service])
            tarif_sets[tarif][part][common_services_id] = [common_service]
          end
        else
          tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
            services_with_common_services = allowed_common_services + services
            services_with_common_services_id = tarif_set_id(services_with_common_services)
            tarif_sets[tarif][part][services_with_common_services_id] = services_with_common_services
          end
        end
      end
    end
#    raise(StandardError)
  end

  def check_allowed_common_services(common_services_to_check, tarif)
    allowed_common_services = []
    common_services_to_check.collect do |common_service|
      if !dependencies[common_service]['prerequisites'].blank? and dependencies[common_service]['prerequisites'].include?(tarif)
        allowed_common_services << common_service
      end
      
      if !dependencies[common_service]['forbidden_tarifs']['to_switch_on'].blank? and !dependencies[common_service]['forbidden_tarifs']['to_switch_on'].include?(tarif)
        allowed_common_services << common_service
      end
      
      if dependencies[common_service]['prerequisites'].blank? and dependencies[common_service]['forbidden_tarifs']['to_switch_on'].blank?
        allowed_common_services << common_service
      end
    end
    allowed_common_services
  end
  
  def calculate_tarif_options_slices
#    raise(StandardError)
    @tarif_options_slices = {}
    tarif_option_combinations.each do |tarif, service_pack|
      operator = service_description[tarif][:operator_id].to_i
      tarif_options_slices[operator] ||= []
      service_pack.each do |part, tarif_option_sets|
#        next if ['onetime', 'periodic'].include?(part)
        tarif_option_sets.each do |tarif_set_id, tarif_options|
          slice = 0
          tarif_options.reverse.each do |tarif_option|
            next if tarif_option.blank?
            tarif_options_slices[operator][slice] ||= {:ids => [], :prev_ids => [], :set_ids => [], :prev_set_ids => [], :uniq_set_ids => {}, :parts => []}
            tarif_option_general_priority = dependencies[tarif_option]['general_priority']
            break if tarif_option_general_priority != gp_tarif_option  #change next on break 31/07/14
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
#        next if ['onetime', 'periodic'].include?(part)
        tarif_sets.each do |tarif_set_id, services|
          slice = 0; tarif_option_slice = 0
          services.reverse.each do |service|
            next if service.blank?
            tarifs_slices[operator][slice] ||= {:ids => [], :prev_ids => [], :set_ids => [], :prev_set_ids => [], :uniq_set_ids => {}, :parts => []}
            service_general_priority = dependencies[service]['general_priority']

            if service_general_priority == gp_tarif_option and slice == 0
              tarif_option_slice += 1
#TODO  разобраться что делать с неправильным порядком
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
                  set_id = tarif_set_id(set_ids)
                  prev_ids = services.reverse[0..(current_service_index - 1)].reverse
                  uniq_set_id = tarif_set_id_with_part(set_ids, part)
                end
                if !tarifs_slices[operator][slice][:uniq_set_ids][uniq_set_id] 
                  tarifs_slices[operator][slice][:uniq_set_ids][uniq_set_id] = uniq_set_id
                  tarifs_slices[operator][slice][:prev_ids] << prev_ids
                  tarifs_slices[operator][slice][:ids] << service
                  tarifs_slices[operator][slice][:prev_set_ids] << tarif_set_id(prev_ids)
                  tarifs_slices[operator][slice][:set_ids] << set_id 
                  tarifs_slices[operator][slice][:parts] << part 
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
                end
              end  
              slice += 1            
            end
          end
        end  
      end
    end
  end

  def calculate_max_tarif_options_slice(operator_1 = nil, tarif_1 = nil)
    @max_tarif_options_slice = {}; @tarif_options_count = {}
    (operator_1 ? [operator_1] : operators).each do |operator| 
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
  
  def calculate_max_tarifs_slice(operator_1 = nil, tarif_1 = nil)
    @max_tarifs_slice = {}; @tarifs_count = {}
    (operator_1 ? [operator_1] : operators).each do |operator| 
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
  
  def calculate_all_tarif_parts_count(operator_1 = nil, tarif_1 = nil)
    @all_tarif_parts_count = {}
    (operator_1 ? [operator_1] : operators).each do |operator|
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
