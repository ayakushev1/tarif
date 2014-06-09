Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }
module Calls::Generation
  extend ActiveSupport::Concern
  class Generator < Object
    attr_reader :context, :user_params, :common_params, :initial_inputs
    attr_accessor :customer_generation_params
  
    def initialize(context, customer_calls_generation_params = {}, user_params = {})
      @context = context
      @customer_generation_params = (customer_calls_generation_params.blank? ? default_calls_generation_params : customer_calls_generation_params)
#      raise(StandardError, [customer_generation_params])
      @user_params = set_user_params(user_params)
      @common_params = set_common_params
      @initial_inputs = set_initial_inputs
      self.extend Helper
      @a = _operators
    end
    
    def generate_calls#(params_to_search_optimal_tarif)
      calls = []
#      Customer::Call.where("(id = ?) and (own_phone->>'number' = ?)", user_params[:user_id], user_params['phone_number']).delete_all
       Customer::Call.delete_all
      
      (1..common_params["number_of_days_in_call_list"] ).each do |day|
        i = 0
        [_calls, _sms, _mms,  _3g].each do |base_service_id|
          rouming = choose_rouming_option
          (1..([1, count_per_day_by_base_service(rouming, base_service_id)].max)).each do |day_item|
            call_destination = choose_call_destination(rouming)
            call_direction = choose_call_direction(rouming)
            partner_operator_id, partner_operator_type_id = choose_call_operator(rouming, call_direction, call_destination)
            
            break if ( partner_operator_type_id == _fixed_line ) and [_sms, _mms].include?(base_service_id)
 
            calls << {
              :base_service_id => base_service_id, :base_subservice_id => choose_call_direction(rouming), :user_id => common_params["user_id"],
              :own_phone => {
                :number => common_params["own_phone_number"], :operator_id => common_params["own_operator_id"],
                :region_id => common_params["own_region_id"], :country_id => common_params["own_country_id"] },
              :partner_phone => {
                :number => common_params["others_phone_number"], :operator_id => partner_operator_id, :operator_type_id => partner_operator_type_id,
                :region_id => initial_inputs[rouming][call_destination]['partner_region_id'], :country_id => initial_inputs[rouming][call_destination]['partner_country_id'] },
              :connect => {
                :operator_id => initial_inputs[rouming]["connection_operator"], :region_id => initial_inputs[rouming]["connection_region"], :country_id => initial_inputs[rouming]["connection_country"] },
              :description => {:time => set_date_time(day, i), :duration => duration_by_base_service(rouming, base_service_id),
                :volume => volume_by_base_service(rouming, base_service_id) },
            }
            i += 1
            raise(StandardError, "Calls::generation - region_id is null") if !calls.last[:partner_phone][:region_id] and !(call_destination == :calls_to_abroad)
            raise(StandardError, "Calls::generation - sms or mms on fixed line") if (calls.last[:partner_phone][:operator_type_id] == _fixed_line) and [_sms, _mms].include?(calls.last[:base_service_id]) 
          end
        end
      end

      ActiveRecord::Base.transaction do
        Customer::Call.create(calls)
      end
    end
    
    def set_user_params(user_params)
      {
        "user_id" => ( ( user_params["user_id"] if user_params ) || 2 ), 
        "own_phone_number" => ( ( user_params["own_phone_number"] if user_params ) || '7000000000' ), 
      }
    end
    
    def set_common_params
      {
        "start_date" => DateTime.civil_from_format(:local, 2014, 1, 1),
        "max_number_of_all_services_per_day" => 10000,
        "number_of_days_in_call_list" => 30,
        "max_duration_of_call" => 60.0, 
        "others_phone_number" => '9999999999',
        "fixed_operator_id" => _fixed_line_operator, 
        "partner_operator_ids" => set_partner_operator_ids(customer_generation_params[:own_region]["operator_id"]),
        "user_id" =>  user_params["user_id"],
        "own_phone_number" => user_params["own_phone_number"], 
        "own_operator_id" => customer_generation_params[:own_region]["operator_id"], 
        "own_region_id" => customer_generation_params[:own_region]["region_id"], 
        "own_country_id" => customer_generation_params[:own_region]["country_id"], 
      }
    end
    
    def set_partner_operator_ids(own_operator_id)
      result = []
      case own_operator_id.to_i
      when _beeline
        result = [_megafon, _mts]
      when _megafon
        result = [_beeline, _mts]
      when _mts
        result = [_beeline, _megafon]
      else
        result = [_beeline, _megafon, _mts]
      end
      result       
    end

    def set_initial_inputs
      p = customer_generation_params
      {
        :own_region => 
          {
            :calls_to_own_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_home_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:home_region]["home_region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_own_country => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_for_region_calls_ids"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_abroad => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => Relation.country_operators(p[:own_region]["country_for_international_calls_ids"]), 
              "partner_region_id" => nil,
              "partner_country_id" => p[:own_region]["country_for_international_calls_ids"],
            },  
            "connection_region" => p[:own_region]["region_id"],
            "connection_country" => p[:own_region]["country_id"],
            "connection_operator" => p[:own_region]["operator_id"],
            "average_duration_of_call" => average_duration_of_call(:own_region),  
            "number_of_day_calls" => p[:own_region]["number_of_day_calls"],  
            "share_of_calls_to_own_mobile" => share_of_calls_to_own_mobile(:own_region),
            "share_of_calls_to_others_mobile" => share_of_calls_to_others_mobile(:own_region),
            "share_of_calls_to_fix_line" => share_of_calls_to_fix_line(:own_region),
            "share_of_local_calls" => share_of_local_calls(:own_region),
            "share_of_international_calls" => share_of_international_calls(:own_region),
            "share_of_incoming_calls" => share_of_incoming_calls(:own_region),
            "share_of_incoming_calls_from_own_mobile" => share_of_incoming_calls_from_own_mobile(:own_region),
            'number_of_sms_per_day' => p[:own_region]["number_of_sms_per_day"],
            'number_of_mms_per_day' => p[:own_region]["number_of_mms_per_day"],
            'internet_trafic_per_month' => p[:own_region]["internet_trafic_per_month"],            
         },
        :home_region => 
          {
            :calls_to_own_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_home_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:home_region]["home_region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_own_country => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_for_region_calls_ids"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_abroad => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => Relation.country_operators(p[:own_region]["country_for_international_calls_ids"]), 
              "partner_region_id" => nil,
              "partner_country_id" => p[:own_region]["country_for_international_calls_ids"],
            },  
            "connection_region" => p[:home_region]["home_region_id"],
            "connection_country" => p[:own_region]["country_id"],
            "connection_operator" => p[:own_region]["operator_id"],
            "average_duration_of_call" => average_duration_of_call(:home_region),  
            "number_of_day_calls" => p[:home_region]["number_of_day_calls"],  
            "share_of_calls_to_own_mobile" => share_of_calls_to_own_mobile(:home_region),
            "share_of_calls_to_others_mobile" => share_of_calls_to_others_mobile(:home_region),
            "share_of_calls_to_fix_line" => share_of_calls_to_fix_line(:home_region),
            "share_of_local_calls" => share_of_local_calls(:home_region),
            "share_of_international_calls" => share_of_international_calls(:home_region),
            "share_of_incoming_calls" => share_of_incoming_calls(:home_region),
            "share_of_incoming_calls_from_own_mobile" => share_of_incoming_calls_from_own_mobile(:home_region),
            'number_of_sms_per_day' => p[:home_region]["number_of_sms_per_day"],
            'number_of_mms_per_day' => p[:home_region]["number_of_mms_per_day"],
            'internet_trafic_per_month' => p[:home_region]["internet_trafic_per_month"],            
         },
        :own_country => 
          {
            :calls_to_own_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_home_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:home_region]["home_region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_own_country => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_for_region_calls_ids"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_abroad => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => Relation.country_operators(p[:own_region]["country_for_international_calls_ids"]), 
              "partner_region_id" => nil,
              "partner_country_id" => p[:own_region]["country_for_international_calls_ids"],
            },  
            "connection_region" => p[:own_country]["travel_region_id"],
            "connection_country" => p[:own_region]["country_id"],
            "connection_operator" => p[:own_region]["operator_id"],
            "average_duration_of_call" => average_duration_of_call(:own_country),  
            "number_of_day_calls" => p[:own_country]["number_of_day_calls"],  
            "share_of_calls_to_own_mobile" => share_of_calls_to_own_mobile(:own_country),
            "share_of_calls_to_others_mobile" => share_of_calls_to_others_mobile(:own_country),
            "share_of_calls_to_fix_line" => share_of_calls_to_fix_line(:own_country),
            "share_of_local_calls" => share_of_local_calls(:own_country),
            "share_of_international_calls" => share_of_international_calls(:own_country),
            "share_of_incoming_calls" => share_of_incoming_calls(:own_country),
            "share_of_incoming_calls_from_own_mobile" => share_of_incoming_calls_from_own_mobile(:own_country),
            'number_of_sms_per_day' => p[:own_country]["number_of_sms_per_day"],
            'number_of_mms_per_day' => p[:own_country]["number_of_mms_per_day"],
            'internet_trafic_per_month' => p[:own_country]["internet_trafic_per_month"],            
         },
        :abroad => 
          {
            :calls_to_own_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_home_region => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:home_region]["home_region_id"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_own_country => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => common_params["partner_operator_ids"], 
              "partner_region_id" => p[:own_region]["region_for_region_calls_ids"],
              "partner_country_id" => p[:own_region]["country_id"],
            },  
            :calls_to_abroad => {
              "partner_phone_number" => common_params["others_phone_number"], 
              "partner_operator_ids" => Relation.country_operators(p[:own_region]["country_for_international_calls_ids"]), 
              "partner_region_id" => nil,
              "partner_country_id" => p[:own_region]["country_for_international_calls_ids"],
            },  
            "connection_region" => nil,
            "connection_country" => p[:abroad]["foreign_country_id"],
            "connection_operator" => Relation.country_operator(p[:abroad]["foreign_country_id"]),
            "average_duration_of_call" => average_duration_of_call(:abroad),  
            "number_of_day_calls" => p[:abroad]["number_of_day_calls"],  
            "share_of_calls_to_own_mobile" => share_of_calls_to_own_mobile(:abroad),
            "share_of_calls_to_others_mobile" => share_of_calls_to_others_mobile(:abroad),
            "share_of_calls_to_fix_line" => share_of_calls_to_fix_line(:abroad),
            "share_of_local_calls" => share_of_local_calls(:abroad),
            "share_of_international_calls" => share_of_international_calls(:abroad),
            "share_of_incoming_calls" => share_of_incoming_calls(:abroad),
            "share_of_incoming_calls_from_own_mobile" => share_of_incoming_calls_from_own_mobile(:abroad),
            'number_of_sms_per_day' => p[:abroad]["number_of_sms_per_day"],
            'number_of_mms_per_day' => p[:abroad]["number_of_mms_per_day"],
            'internet_trafic_per_month' => p[:abroad]["internet_trafic_per_month"],            
         },
      }
    end
    
    def choose_rouming_option
      p = customer_generation_params
      own_reg = p[:own_region]["share_of_time_in_own_region"].to_f
      home_reg = own_reg + p[:own_region]["share_of_time_in_home_region"].to_f
      country_reg = home_reg + p[:own_region]["share_of_time_in_own_country"].to_f
      
      case rand 
      when 0..own_reg
        :own_region
      when own_reg..home_reg
        :home_region
      when home_reg..country_reg
        :own_country
      else
        :abroad
      end
    end
    
    def choose_call_direction(rouming)
      case rand 
      when 0..initial_inputs[rouming]["share_of_incoming_calls"].to_f
        _inbound
      else
        _outbound
      end
    end
    
    def choose_call_operator(rouming, call_direction, call_destination = nil)
      (call_direction == _inbound) ? choose_incoming_calls_operator(rouming) : choose_outcoming_calls_operator(rouming, call_destination)
    end
    
    def choose_incoming_calls_operator(rouming)
      case rand 
      when 0..share_of_incoming_calls_from_own_mobile(rouming).to_f
        [common_params["own_operator_id"], _mobile]
      else
        [choose_random_from_array( initial_inputs[rouming][:calls_to_own_region]["partner_operator_ids"] ), _mobile]
      end
    end
    
    def choose_outcoming_calls_operator(rouming, call_destination)
      case rand 
      when 0..share_of_calls_to_fix_line(rouming)
        [common_params['fixed_operator_id'], _fixed_line]
      when share_of_calls_to_fix_line(rouming)..(share_of_calls_to_fix_line(rouming) + share_of_calls_to_others_mobile(rouming) )
        [choose_random_from_array( initial_inputs[rouming][call_destination]["partner_operator_ids"] ), _mobile]        
      when ( share_of_calls_to_fix_line(rouming) + share_of_calls_to_others_mobile(rouming) )..1
        [common_params["own_operator_id"], _mobile]
      else
        [common_params["own_operator_id"], _mobile]
      end
    end
    
    def choose_call_destination(rouming)
      destination = case rand 
        when 0..share_of_local_calls(rouming)
          rand < 0.7 ? :calls_to_own_region : :calls_to_home_region 
        when share_of_local_calls(rouming)..(share_of_local_calls(rouming) + share_of_regional_calls(rouming) )
          :calls_to_own_country
        when (share_of_local_calls(rouming) + share_of_regional_calls(rouming) )..1
          :calls_to_abroad
        else
          :calls_to_own_region
        end
    end
 
    def choose_random_from_array(arr)
      arr ? arr[(rand * arr.count).floor] : nil
    end
    
    def average_duration_of_call(rouming)
      p = customer_generation_params
      ( (p[rouming]["duration_of_calls"].to_f > 10.0 / 60.0) ?  p[rouming]["duration_of_calls"].to_f : 10.0 / 60.0 )
    end
    
    def share_of_calls_to_own_mobile(rouming)
      p = customer_generation_params
      (1 - p[rouming]["share_of_calls_to_other_mobile"].to_f - p[rouming]["share_of_calls_to_fix_line"].to_f )
    end
    
    def share_of_calls_to_others_mobile(rouming)
      customer_generation_params[rouming]["share_of_calls_to_other_mobile"].to_f 
    end
    
    def share_of_calls_to_fix_line(rouming)
      customer_generation_params[rouming]["share_of_calls_to_fix_line"].to_f 
    end
    
    def share_of_local_calls(rouming)
      p = customer_generation_params
      ( 1 - share_of_regional_calls(rouming) - share_of_international_calls(rouming) )
    end
    
    def share_of_regional_calls(rouming)
      p = customer_generation_params
      ( p[rouming]["share_of_regional_calls"].to_f )
    end
  
    def share_of_international_calls(rouming)
      p = customer_generation_params
      ( p[rouming]["share_of_international_calls"].to_f )
    end
  
    def share_of_outcoming_calls(rouming)
      1 - share_of_incoming_calls(rouming).to_f 
    end
    
    def share_of_incoming_calls(rouming)
      customer_generation_params[rouming]["share_of_incoming_calls"].to_f 
    end
    
    def share_of_incoming_calls_from_own_mobile(rouming)
      customer_generation_params[rouming]["share_of_incoming_calls_from_own_mobile"].to_f 
    end
    
    def default_calls_generation_params
      self.class.default_calls_generation_params
    end
    
    def average_internet_volume_per_day(rouming)
      initial_inputs[rouming]["internet_trafic_per_month"].to_f*1000.0/ common_params['number_of_days_in_call_list'].to_f
    end
    
    def count_per_day_by_base_service(rouming, base_service_id)
      case base_service_id
      when _calls
        initial_inputs[rouming]["number_of_day_calls"].to_i
      when _2g, _3g, _4g, _cdma
        1
      when _sms
        initial_inputs[rouming]["number_of_sms_per_day"].to_i
      when _mms
        initial_inputs[rouming]["number_of_mms_per_day"].to_i
      when _one_time
        1
      when _periodic
        1
      end 
    end
        
    def duration_by_base_service(rouming, base_service_id)
      base_service_id == _calls ? random(initial_inputs[rouming]["average_duration_of_call"]) * 60.0 : nil
    end
        
    def volume_by_base_service(rouming, base_service_id)
      case base_service_id
      when _calls
        nil
      when _2g, _3g, _4g, _cdma
        average_internet_volume_per_day(rouming).to_i
      when _sms
        1
      when _mms
        1
      when _one_time
        1
      when _periodic
        1
      end 
    end
    
    def set_date_time(day, i)
      n = common_params["max_number_of_all_services_per_day"]
      hour = (24.0*i/n).floor; min = ((24.0*i/n - hour)*60.0).floor; sec = (((24.0*i/n - hour)*60.0 - min)*60.0).floor 
      date_time = common_params["start_date"].change({:year=>2014, :month=>1, :day => day, :hour => hour, :min => min, :sec => sec })                
    end
        
    def self.default_calls_generation_params(usage_pattern_id = nil)
      {
        :own_region => 
          {
          'phone_usage_type_id' => _own_region_active_caller,
          'country_id' => _russia,
          'region_id' => _moscow, 
          'operator_id' => _mts,
          'privacy_id' => _person,
          'region_for_region_calls_ids' => _piter,
          'country_for_international_calls_ids' => _ukraiun,
         }.merge(usage_pattern(usage_pattern_id || _own_region_active_caller) ),
        :home_region => 
          {
          'phone_usage_type_id' => _home_region_no_activity,
          'country_id' => _russia,
          'home_region_id' => _moscow_region, 
         }.merge(usage_pattern(usage_pattern_id || _home_region_no_activity) ),
        :own_country => 
          {
          'phone_usage_type_id' => _own_country_no_activity,
          'country_id' => _russia,
          'travel_region_id' => _piter, 
         }.merge(usage_pattern(usage_pattern_id || _own_country_no_activity) ),
        :abroad => 
          {
          'phone_usage_type_id' => _abroad_no_activity,
          'continent_id' => _europe, 
          'foreign_country_id' => _ukraiun,
         }.merge(usage_pattern(usage_pattern_id || _abroad_no_activity) ),
        
      }
    end
    
    def self.usage_pattern(usage_pattern_id)
      case usage_pattern_id.to_i
      when _own_region_active_caller
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3, 'share_of_time_in_own_region' => 0.6, 
        'share_of_time_in_home_region' => 0.2,'share_of_time_in_own_country' => 0.15, 'share_of_time_abroad' => 0.05 }
      when _own_region_active_sms
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3, 'share_of_time_in_own_region' => 0.7, 
        'share_of_time_in_home_region' => 0.2, 'share_of_time_in_own_country' => 0.1, 'share_of_time_abroad' => 0.0 }
      when _own_region_active_internet
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 10,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3, 'share_of_time_in_own_region' => 0.7, 
        'share_of_time_in_home_region' => 0.2, 'share_of_time_in_own_country' => 0.1, 'share_of_time_abroad' => 0.0 }
      when _home_region_active_caller
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _home_region_active_sms
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _home_region_active_internet
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 10,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _home_region_no_activity
        {"number_of_day_calls" => 1, "duration_of_calls" => 1, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 1, "internet_trafic_per_month" => 20,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _own_country_active_caller
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _own_country_active_sms
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _own_country_active_internet
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 10,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _own_country_no_activity
        {"number_of_day_calls" => 1, "duration_of_calls" => 1, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 1, "internet_trafic_per_month" => 20,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _abroad_active_caller
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _abroad_active_sms
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _abroad_active_internet
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 10,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      when _abroad_no_activity
        {"number_of_day_calls" => 1, "duration_of_calls" => 1, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 1, "internet_trafic_per_month" => 20,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      else
        {"number_of_day_calls" => 1, "duration_of_calls" => 5, "share_of_calls_to_other_mobile" => 0.7, "share_of_calls_to_fix_line" => 0.1,
        "share_of_regional_calls" => 0.1, "share_of_international_calls" => 0.05, "number_of_sms_per_day" => 1, "number_of_mms_per_day" => 2, "internet_trafic_per_month" => 2,
        'share_of_incoming_calls' => 0.5, 'share_of_incoming_calls_from_own_mobile'=> 0.3}
      end
    end
  
    module Helper
      def random(average)
        x = rand
        pi = 3.1415926535897932384626433832#BigMath.PI(10)
        if x < 0.25
          Math.sin(x * average * pi) * average
        else
          average * 5.0 + Math.sin((x - 3.0/4.0) * pi) * average * 4.0
        end
      end
      
    end
    
  end


end
