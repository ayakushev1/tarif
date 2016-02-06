Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

class Calls::Generator
  extend ActiveSupport::Concern
  attr_reader :user_params, :common_params, :initial_inputs
  attr_accessor :customer_generation_params

  def initialize(customer_calls_generation_params = {}, user_params = {})
#    raise(StandardError, user_params)
    @customer_generation_params = (customer_calls_generation_params.blank? ? default_calls_generation_params : customer_calls_generation_params)
#      raise(StandardError, [customer_calls_generation_params.blank?, customer_generation_params])
    @user_params = set_user_params(user_params)
    @common_params = set_common_params
    @initial_inputs = set_initial_inputs
#    raise(StandardError, [customer_calls_generation_params[:own_region][:own_region], common_params, initial_inputs].join("\n"))
    self.extend Helper
#      @a = _operators
#      raise(StandardError, [customer_calls_generation_params, user_params, common_params, initial_inputs].join("\n\n"))
  end
  
  def self.generate_calls_from_one_to_other_operator(operator_id_1, call_run_id_1, operator_id_2, call_run_id_2)
    calls = []
    categories = {} 
    ::Category.where(:id => [operator_id_1, operator_id_2]).each { |o| categories[o.id] = o.name }

    Customer::Call.where(:call_run_id => call_run_id_1).each do |call|
      call_item = call.attributes.deep_symbolize_keys
#      raise(StandardError, call_item)
      case 
      when call_item[:partner_phone][:operator_id] == operator_id_1
        partner_operator_id = operator_id_2
        partner_operator = categories[partner_operator_id]
      when call_item[:partner_phone][:operator_id] == operator_id_2
        partner_operator_id = operator_id_1
        partner_operator = categories[partner_operator_id]
      else
        partner_operator_id = call_item[:partner_phone][:operator_id]
        partner_operator = call_item[:partner_phone][:operator]
      end

      case 
      when call_item[:connect][:operator_id] == operator_id_1
        connect_operator_id = operator_id_2
        connect_operator = categories[connect_operator_id]
      when call_item[:connect][:operator_id] == operator_id_2
        connect_operator_id = operator_id_1
        connect_operator = categories[connect_operator_id]
      else
        connect_operator_id = call_item[:connect][:operator_id]
        connect_operator = call_item[:connect][:operator]
      end
        
      call_item.deep_merge!({
        :call_run_id => call_run_id_2,
        :own_phone => {
          :operator_id => operator_id_2,
          :operator => categories[operator_id_2],
          },
        :partner_phone => {
          :operator_id => partner_operator_id, 
          :operator => partner_operator,
          },
        :connect => {
          :operator_id => connect_operator_id, 
          :operator => connect_operator,
          },
      })
      calls << call_item
    end
    Customer::Call.bulk_insert values: calls
  end
  
  def generate_calls#(params_to_search_optimal_tarif)
    calls = []
    categories = {} 
    ::Category.all.each { |o| categories[o.id] = o.name }
    
    (1..common_params["number_of_days_in_call_list".freeze] ).each do |day|
        i = 0
        [_calls, _sms, _mms,  _3g].each do |base_service_id|
          rouming = choose_rouming_option
          
          max_count_per_day_by_base_service = [0, count_per_day_by_base_service(rouming, base_service_id)].max
          next if max_count_per_day_by_base_service == 0
          
          (0...max_count_per_day_by_base_service).each do |day_item|
            call_destination = choose_call_destination(rouming)
            call_direction = choose_call_direction(rouming)
            partner_operator_id, partner_operator_type_id, partner_region_id, partner_country_id = choose_call_operator(rouming, call_direction, call_destination)
            
            next if ( partner_operator_type_id == _fixed_line ) and [_sms, _mms].include?(base_service_id)
            
            base_subservice_id = (base_service_id == _3g ? _inbound : choose_call_direction(rouming))
 
            call_item = {
              :base_service_id => base_service_id, :base_subservice_id => base_subservice_id, 
              :user_id => common_params["user_id".freeze], :call_run_id => common_params["call_run_id".freeze],
            :own_phone => {
              :number => common_params["own_phone_number".freeze], :operator_id => common_params["own_operator_id".freeze],
              :region_id => common_params["own_region_id".freeze], :country_id => common_params["own_country_id".freeze],
              :operator => categories[common_params["own_operator_id".freeze]],
              :region => categories[common_params["own_region_id".freeze]],
              :country => categories[common_params["own_country_id".freeze]],
              },
            :partner_phone => {
              :number => common_params["others_phone_number".freeze], :operator_id => partner_operator_id, :operator_type_id => partner_operator_type_id,
              :region_id => partner_region_id, :country_id => partner_country_id, 
              :operator => categories[partner_operator_id],
              :operator_type => categories[partner_operator_type_id],
              :region => categories[partner_region_id],
              :country => categories[partner_country_id],
              },
            :connect => {
              :operator_id => initial_inputs[rouming]["connection_operator".freeze], :region_id => initial_inputs[rouming]["connection_region".freeze], 
              :country_id => initial_inputs[rouming]["connection_country".freeze], 
              :operator => categories[initial_inputs[rouming]["connection_operator".freeze]],
              :region => categories[initial_inputs[rouming]["connection_region".freeze]],
              :country => categories[initial_inputs[rouming]["connection_country".freeze]],
              },
            :description => {
              :time => set_date_time(day, i).to_s, :day => day, :month => set_month, :year => set_year, 
              :date => set_date_time(day, i).to_date.to_s, :date_number => day, :accounting_period => "#{set_month}_#{set_year}",
              :duration => duration_by_base_service(rouming, base_service_id),
              :volume => volume_by_base_service(rouming, base_service_id) },
          }
          i += 1
          next if (call_item[:description][:duration].to_f == 0.0 and call_item[:description][:volume].to_f == 0.0)
          p = customer_generation_params
#    raise(StandardError, call_item)

          calls << call_item
#          raise(StandardError, "Calls::generator - region_id is null") if !calls.last[:partner_phone][:region_id] and !(call_destination == :calls_to_abroad)
#          raise(StandardError, "Calls::generatoe - sms or mms on fixed line") if (calls.last[:partner_phone][:operator_type_id] == _fixed_line) and [_sms, _mms].include?(calls.last[:base_service_id]) 
        end
      end
    end
    
    Customer::Call.batch_save(calls, {:user_id => user_params["user_id".freeze], :call_run_id => user_params["call_run_id".freeze]})

  end

  def set_user_params(user_params)
    result = {
      "user_id".freeze => user_params["user_id".freeze], #( ( user_params["user_id"] if user_params ) || 2 ).to_i, 
      "own_phone_number".freeze => ( ( user_params["own_phone_number".freeze] if user_params ) || '7000000000'.freeze ), 
      'call_run_id'.freeze => user_params["call_run_id".freeze]
    }
  end
  
  def set_common_params
      begin
    {
      "start_date".freeze => DateTime.civil_from_format(:local, 2014, 1, 1),
      "max_number_of_all_services_per_day".freeze => 10000,
      "number_of_days_in_call_list".freeze => 30,
      "max_duration_of_call".freeze => 60.0, 
      "others_phone_number".freeze => '9999999999',
      "fixed_operator_id".freeze => Category::Operator::Const::FixedlineOperator, 
      "partner_operator_ids".freeze => set_partner_operator_ids(customer_generation_params[:general]["operator_id"].to_i),
      "user_id".freeze =>  user_params["user_id".freeze],
      "call_run_id".freeze =>  user_params["call_run_id".freeze],
      "own_phone_number".freeze => user_params["own_phone_number".freeze], 
      "own_operator_id".freeze => customer_generation_params[:general]["operator_id".freeze].to_i, 
      "own_region_id".freeze => customer_generation_params[:general]["region_id".freeze].to_i, 
      "own_country_id".freeze => customer_generation_params[:general]["country_id".freeze].to_i, 
    }
      rescue
        raise(StandardError, [result, customer_generation_params[:general]])
      end
  end
  
  def set_partner_operator_ids(own_operator_id)
    result = []
    case own_operator_id.to_i
    when Category::Operator::Const::Beeline
      result = [Category::Operator::Const::Megafon, Category::Operator::Const::Mts, Category::Operator::Const::Tele2]
    when Category::Operator::Const::Megafon
      result = [Category::Operator::Const::Mts, Category::Operator::Const::Tele2, Category::Operator::Const::Beeline]
    when Category::Operator::Const::Mts
      result = [Category::Operator::Const::Tele2, Category::Operator::Const::Beeline, Category::Operator::Const::Megafon]
    when Category::Operator::Const::Tele2
      result = [Category::Operator::Const::Beeline, Category::Operator::Const::Megafon, Category::Operator::Const::Mts]
    else
      result = [Category::Operator::Const::Beeline, Category::Operator::Const::Megafon, Category::Operator::Const::Mts, Category::Operator::Const::Tele2]
    end
    result       
  end

  def set_initial_inputs
    p = customer_generation_params
    {
      :own_region => 
        {
          :calls_to_own_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:general]["region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_home_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:home_region]["rouming_region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_own_country => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:own_region]["region_for_region_calls_ids".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_abroad => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => Relation.country_operators(p[:own_region]["country_for_international_calls_ids".freeze]), 
            "partner_region_id".freeze => nil,
            "partner_country_id".freeze => p[:own_region]["country_for_international_calls_ids".freeze],
          },  
          "connection_region".freeze => p[:general]["region_id".freeze].to_i,
          "connection_country".freeze => p[:general]["country_id".freeze].to_i,
          "connection_operator".freeze => p[:general]["operator_id".freeze].to_i,
          "average_duration_of_call".freeze => average_duration_of_call(:own_region),  
          "number_of_day_calls".freeze => p[:own_region]["number_of_day_calls".freeze],  
          "share_of_calls_to_own_mobile".freeze => share_of_calls_to_own_mobile(:own_region),
          "share_of_calls_to_others_mobile".freeze => share_of_calls_to_others_mobile(:own_region),
          "share_of_calls_to_fix_line".freeze => share_of_calls_to_fix_line(:own_region),
          "share_of_local_calls".freeze => share_of_local_calls(:own_region),
          "share_of_international_calls".freeze => share_of_international_calls(:own_region),
          "share_of_incoming_calls".freeze => share_of_incoming_calls(:own_region),
          "share_of_incoming_calls_from_own_mobile".freeze => share_of_incoming_calls_from_own_mobile(:own_region),
          'number_of_sms_per_day'.freeze => p[:own_region]["number_of_sms_per_day".freeze],
          'number_of_mms_per_day'.freeze => p[:own_region]["number_of_mms_per_day".freeze],
          'internet_trafic_per_month'.freeze => p[:own_region]["internet_trafic_per_month".freeze],            
       },
      :home_region => 
        {
          :calls_to_own_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:general]["region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_home_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:home_region]["rouming_region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_own_country => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:own_region]["region_for_region_calls_ids".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_abroad => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => Relation.country_operators(p[:own_region]["country_for_international_calls_ids".freeze]), 
            "partner_region_id".freeze => nil,
            "partner_country_id".freeze => p[:own_region]["country_for_international_calls_ids".freeze],
          },  
          "connection_region".freeze => p[:home_region]["rouming_region_id".freeze].to_i,
          "connection_country".freeze => p[:general]["country_id".freeze].to_i,
          "connection_operator".freeze => p[:general]["operator_id".freeze].to_i,
          "average_duration_of_call".freeze => average_duration_of_call(:home_region),  
          "number_of_day_calls".freeze => p[:home_region]["number_of_day_calls".freeze],  
          "share_of_calls_to_own_mobile".freeze => share_of_calls_to_own_mobile(:home_region),
          "share_of_calls_to_others_mobile".freeze => share_of_calls_to_others_mobile(:home_region),
          "share_of_calls_to_fix_line".freeze => share_of_calls_to_fix_line(:home_region),
          "share_of_local_calls".freeze => share_of_local_calls(:home_region),
          "share_of_international_calls".freeze => share_of_international_calls(:home_region),
          "share_of_incoming_calls".freeze => share_of_incoming_calls(:home_region),
          "share_of_incoming_calls_from_own_mobile".freeze => share_of_incoming_calls_from_own_mobile(:home_region),
          'number_of_sms_per_day'.freeze => p[:home_region]["number_of_sms_per_day".freeze],
          'number_of_mms_per_day'.freeze => p[:home_region]["number_of_mms_per_day".freeze],
          'internet_trafic_per_month'.freeze => p[:home_region]["internet_trafic_per_month".freeze],            
       },
      :own_country => 
        {
          :calls_to_own_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:general]["region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_home_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:home_region]["rouming_region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_own_country => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:own_region]["region_for_region_calls_ids".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_abroad => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => Relation.country_operators(p[:own_region]["country_for_international_calls_ids".freeze]), 
            "partner_region_id".freeze => nil,
            "partner_country_id".freeze => p[:own_region]["country_for_international_calls_ids".freeze],
          },  
          "connection_region".freeze => p[:own_country]["rouming_region_id".freeze].to_i,
          "connection_country".freeze => p[:general]["country_id".freeze].to_i,
          "connection_operator".freeze => p[:general]["operator_id".freeze].to_i,
          "average_duration_of_call".freeze => average_duration_of_call(:own_country),  
          "number_of_day_calls".freeze => p[:own_country]["number_of_day_calls".freeze],  
          "share_of_calls_to_own_mobile".freeze => share_of_calls_to_own_mobile(:own_country),
          "share_of_calls_to_others_mobile".freeze => share_of_calls_to_others_mobile(:own_country),
          "share_of_calls_to_fix_line".freeze => share_of_calls_to_fix_line(:own_country),
          "share_of_local_calls".freeze => share_of_local_calls(:own_country),
          "share_of_international_calls".freeze => share_of_international_calls(:own_country),
          "share_of_incoming_calls".freeze => share_of_incoming_calls(:own_country),
          "share_of_incoming_calls_from_own_mobile".freeze => share_of_incoming_calls_from_own_mobile(:own_country),
          'number_of_sms_per_day'.freeze => p[:own_country]["number_of_sms_per_day".freeze],
          'number_of_mms_per_day'.freeze => p[:own_country]["number_of_mms_per_day".freeze],
          'internet_trafic_per_month'.freeze => p[:own_country]["internet_trafic_per_month".freeze],            
       },
      :abroad => 
        {
          :calls_to_own_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:general]["region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_home_region => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:home_region]["rouming_region_id".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_own_country => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => common_params["partner_operator_ids".freeze], 
            "partner_region_id".freeze => p[:own_region]["region_for_region_calls_ids".freeze].to_i,
            "partner_country_id".freeze => p[:general]["country_id".freeze].to_i,
          },  
          :calls_to_abroad => {
            "partner_phone_number".freeze => common_params["others_phone_number".freeze], 
            "partner_operator_ids".freeze => Relation.country_operators(p[:own_region]["country_for_international_calls_ids".freeze]), 
            "partner_region_id".freeze => nil,
            "partner_country_id".freeze => p[:own_region]["country_for_international_calls_ids".freeze].to_i,
          },  
          "connection_region".freeze => nil,
          "connection_country".freeze => p[:abroad]["rouming_country_id".freeze].to_i,
          "connection_operator".freeze => Relation.country_operator(p[:abroad]["rouming_country_id".freeze]).to_i,
          "average_duration_of_call".freeze => average_duration_of_call(:abroad).to_i,  
          "number_of_day_calls".freeze => p[:abroad]["number_of_day_calls".freeze].to_i,  
          "share_of_calls_to_own_mobile".freeze => share_of_calls_to_own_mobile(:abroad),
          "share_of_calls_to_others_mobile".freeze => share_of_calls_to_others_mobile(:abroad),
          "share_of_calls_to_fix_line".freeze => share_of_calls_to_fix_line(:abroad),
          "share_of_local_calls".freeze => share_of_local_calls(:abroad),
          "share_of_international_calls".freeze => share_of_international_calls(:abroad),
          "share_of_incoming_calls".freeze => share_of_incoming_calls(:abroad),
          "share_of_incoming_calls_from_own_mobile".freeze => share_of_incoming_calls_from_own_mobile(:abroad),
          'number_of_sms_per_day'.freeze => p[:abroad]["number_of_sms_per_day".freeze].to_i,
          'number_of_mms_per_day'.freeze => p[:abroad]["number_of_mms_per_day".freeze].to_i,
          'internet_trafic_per_month'.freeze => p[:abroad]["internet_trafic_per_month".freeze].to_f,            
       },
    }
  end
  
  def choose_rouming_option
    p = customer_generation_params
    own_reg = p[:general]["share_of_time_in_own_region".freeze].to_f
    home_reg = own_reg + p[:general]["share_of_time_in_home_region".freeze].to_f
    country_reg = home_reg + p[:general]["share_of_time_in_own_country".freeze].to_f
    abroad = country_reg + p[:general]["share_of_time_abroad".freeze].to_f
    
    result = case rand * abroad
    when 0...own_reg
      :own_region
    when own_reg...home_reg
      p[:home_region]["phone_usage_type_id".freeze].to_i == _home_region_no_activity ? :own_region : :home_region
    when home_reg...country_reg
      p[:own_country]["phone_usage_type_id".freeze].to_i == _own_country_no_activity ? :own_region : :own_country        
    else
      p[:abroad]["phone_usage_type_id".freeze].to_i == _abroad_no_activity ? :own_region : :abroad                
#      raise(StandardError)
    end
    result
#    raise(StandardError, result)
  end
  
  def choose_call_direction(rouming)
    case rand 
    when 0...initial_inputs[rouming]["share_of_incoming_calls".freeze].to_f
      _inbound
    else
      _outbound
    end
  end
  
  def choose_call_operator(rouming, call_direction, call_destination = nil)
    (call_direction == _inbound) ? choose_incoming_calls_operator(rouming, call_destination) : choose_outcoming_calls_operator(rouming, call_destination)
  end
  
  def choose_incoming_calls_operator(rouming, call_destination)
    case rand 
    when 0...share_of_incoming_calls_from_own_mobile(rouming).to_f
      partner_operator_id = if call_destination == :calls_to_abroad
        choose_random_from_array( initial_inputs[rouming][call_destination]["partner_operator_ids".freeze])
      else
        common_params["own_operator_id".freeze]
      end
      [partner_operator_id, _mobile,
       initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
      ]
    else
      [choose_random_from_array( initial_inputs[rouming][call_destination]["partner_operator_ids".freeze]), _mobile,
       initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
         ]
      end
    end    
 
    def choose_outcoming_calls_operator(rouming, call_destination)
      case rand 
      when 0...share_of_calls_to_fix_line(rouming)
        if call_destination == :calls_to_abroad
          [choose_random_from_array( initial_inputs[rouming][call_destination]["partner_operator_ids".freeze] ), _mobile,
         initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
        ]
        else
          [common_params['fixed_operator_id'.freeze], _fixed_line,
           initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
          ]
        end
    when share_of_calls_to_fix_line(rouming)...(share_of_calls_to_fix_line(rouming) + share_of_calls_to_others_mobile(rouming) )
      [choose_random_from_array( initial_inputs[rouming][call_destination]["partner_operator_ids".freeze] ), _mobile,
       initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
      ]        
    when ( share_of_calls_to_fix_line(rouming) + share_of_calls_to_others_mobile(rouming) )..1
      if call_destination == :calls_to_abroad
        [choose_random_from_array( initial_inputs[rouming][call_destination]["partner_operator_ids".freeze]), _mobile,
         initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
        ]
      else
        [common_params["own_operator_id".freeze], _mobile,
         initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
        ]
      end
    else
      [common_params["own_operator_id".freeze], _mobile,
       initial_inputs[rouming][call_destination]['partner_region_id'.freeze], initial_inputs[rouming][call_destination]['partner_country_id'.freeze]
        ]
      end
    end
    
    def choose_call_destination(rouming)
      destination = case rand 
        when 0...share_of_local_calls(rouming)
          rand < 0.7 ? :calls_to_own_region : :calls_to_home_region 
        when share_of_local_calls(rouming)...(share_of_local_calls(rouming) + share_of_regional_calls(rouming) )
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
      ( (p[rouming]["duration_of_calls".freeze].to_f > 10.0 / 60.0) ?  p[rouming]["duration_of_calls".freeze].to_f : 10.0 / 60.0 )
  end
  
  def share_of_calls_to_own_mobile(rouming)
    p = customer_generation_params
    (1 - p[rouming]["share_of_calls_to_other_mobile".freeze].to_f - p[rouming]["share_of_calls_to_fix_line".freeze].to_f )
  end
  
  def share_of_calls_to_others_mobile(rouming)
    customer_generation_params[rouming]["share_of_calls_to_other_mobile".freeze].to_f 
  end
  
  def share_of_calls_to_fix_line(rouming)
    customer_generation_params[rouming]["share_of_calls_to_fix_line".freeze].to_f 
  end
  
  def share_of_local_calls(rouming)
    p = customer_generation_params
    ( 1 - share_of_regional_calls(rouming) - share_of_international_calls(rouming) )
  end
  
  def share_of_regional_calls(rouming)
    p = customer_generation_params
    ( p[rouming]["share_of_regional_calls".freeze].to_f )
  end

  def share_of_international_calls(rouming)
    p = customer_generation_params
    ( p[rouming]["share_of_international_calls".freeze].to_f )
  end

  def share_of_outcoming_calls(rouming)
    1 - share_of_incoming_calls(rouming).to_f 
  end
  
  def share_of_incoming_calls(rouming)
    customer_generation_params[rouming]["share_of_incoming_calls".freeze].to_f 
  end
  
  def share_of_incoming_calls_from_own_mobile(rouming)
    customer_generation_params[rouming]["share_of_incoming_calls_from_own_mobile".freeze].to_f 
  end
  
  def default_calls_generation_params
    result = {}
    [:general, :own_region, :home_region, :own_country, :abroad].each do |rouming|
      result = result.merge(self.class.default_calls_generation_params(rouming))
    end
    result
  end
  
  def average_internet_volume_per_day(rouming)
#      raise(StandardError, [rouming, initial_inputs[rouming]["internet_trafic_per_month"]]) if rouming == :own_region 
    initial_inputs[rouming]["internet_trafic_per_month".freeze].to_f * 1000.0/ common_params['number_of_days_in_call_list'.freeze].to_f
  end
  
  def count_per_day_by_base_service(rouming, base_service_id)
    case base_service_id
    when _calls
      initial_inputs[rouming]["number_of_day_calls".freeze].to_i
    when _2g, _3g, _4g, _cdma
      initial_inputs[rouming]["internet_trafic_per_month".freeze].to_f < 0.00001 ? 0 : 5
    when _sms
      initial_inputs[rouming]["number_of_sms_per_day".freeze].to_i
    when _mms
      initial_inputs[rouming]["number_of_mms_per_day".freeze].to_i
    when _one_time
      1
    when _periodic
      1
    end 
  end
      
  def duration_by_base_service(rouming, base_service_id)
    average_duraton_of_max_duration = initial_inputs[rouming]["average_duration_of_call".freeze] / common_params["max_duration_of_call".freeze]
    base_service_id == _calls ? initial_inputs[rouming]["average_duration_of_call".freeze] * 60.0 : 0.0
#    base_service_id == _calls ? random(average_duraton_of_max_duration) * common_params["max_duration_of_call"] * 60.0 * 1.61 : 0.0
#    raise(StandardError, [initial_inputs[rouming]["average_duration_of_call"], common_params["max_duration_of_call"], random(average_duraton_of_max_duration) * 60.0 * 1.5 ])
  end
      
  def volume_by_base_service(rouming, base_service_id)
    case base_service_id
    when _calls
      nil
    when _2g, _3g, _4g, _cdma
      average_internet_volume_per_day(rouming).to_f / 5.0
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
  
  def set_year
    2015
  end
  
  def set_month
    1
  end
  
  def set_date_time(day, i)
    n = common_params["max_number_of_all_services_per_day".freeze]
    hour = (24.0*i/n).floor; min = ((24.0*i/n - hour)*60.0).floor; sec = (((24.0*i/n - hour)*60.0 - min)*60.0).floor 
    date_time = common_params["start_date".freeze].change({:year=>set_year, :month=>set_month, :day => day, :hour => hour, :min => min, :sec => sec })                
  end
      
  def self.default_calls_generation_params(rouming, usage_pattern_id = nil)
#      raise(StandardError, usage_pattern_id)
    case rouming
    when :general
      {
        :general => 
        {
        'phone_usage_type_id'.freeze => ((usage_pattern_id and usage_pattern_id.to_i != 0) ? usage_pattern_id.to_i : _general_home_sitter),
        'country_id'.freeze => _russia,
        'region_id'.freeze => _moscow, 
        'operator_id'.freeze => Category::Operator::Const::Mts,
        'privacy_id'.freeze => _person,
         }.merge(usage_pattern(usage_pattern_id || _general_home_sitter) )
       }
    when :own_region
      {
        :own_region => 
        {
        'phone_usage_type_id'.freeze => ((usage_pattern_id and usage_pattern_id.to_i != 0) ? usage_pattern_id.to_i : _own_region_active_caller),
        'country_id'.freeze => _russia,
        'region_id'.freeze => _moscow, 
        'operator_id'.freeze => Category::Operator::Const::Mts,
        'privacy_id'.freeze => _person,
        'region_for_region_calls_ids'.freeze => _piter,
        'country_for_international_calls_ids'.freeze => _great_britain,
         }.merge(usage_pattern(usage_pattern_id || _own_region_active_caller) )
       }
    when :home_region
      {
      :home_region => 
        {
        'phone_usage_type_id'.freeze => ((usage_pattern_id and usage_pattern_id.to_i != 0) ? usage_pattern_id.to_i : _home_region_no_activity),
        'country_id'.freeze => _russia,
        'rouming_region_id'.freeze => _moscow_region, 
       }.merge(usage_pattern(usage_pattern_id || _home_region_no_activity) )          
      }
    when :own_country
      {
      :own_country => 
        {
        'phone_usage_type_id'.freeze => ((usage_pattern_id and usage_pattern_id.to_i != 0) ? usage_pattern_id.to_i : _own_country_no_activity),
        'country_id'.freeze => _russia,
        'rouming_region_id'.freeze => _piter, 
       }.merge(usage_pattern(usage_pattern_id || _own_country_no_activity) )
      }
    when :abroad
      {
      :abroad => 
        {
        'phone_usage_type_id'.freeze => ((usage_pattern_id and usage_pattern_id.to_i != 0) ? usage_pattern_id.to_i : _abroad_no_activity),
        'continent_id'.freeze => _europe, 
        'rouming_country_id'.freeze => _ukraiun,
       }.merge(usage_pattern(usage_pattern_id || _abroad_no_activity) )
      }
    else
      raise(StandardError, "wrong rouming: #{rouming}")
    end
  end

  def self.update_all_usage_patterns_based_on_general_usage_type(general_phone_usage_type_id)
    case general_phone_usage_type_id.to_i
    when _general_home_sitter
      {'customer_calls_generation_params_own_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_region_active_caller}, 
       'customer_calls_generation_params_home_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _home_region_no_activity},
       'customer_calls_generation_params_own_country_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_country_no_activity}, 
       'customer_calls_generation_params_abroad_filtr'.freeze => {'phone_usage_type_id'.freeze => _abroad_no_activity} }
    when _general_home_region_sitter
      {'customer_calls_generation_params_own_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_region_active_caller}, 
       'customer_calls_generation_params_home_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _home_region_active_caller},
       'customer_calls_generation_params_own_country_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_country_no_activity}, 
       'customer_calls_generation_params_abroad_filtr'.freeze => {'phone_usage_type_id'.freeze => _abroad_no_activity} }
    when _general_active_russia_traveller
      {'customer_calls_generation_params_own_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_region_active_caller}, 
       'customer_calls_generation_params_home_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _home_region_active_caller},
       'customer_calls_generation_params_own_country_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_country_active_caller}, 
       'customer_calls_generation_params_abroad_filtr'.freeze => {'phone_usage_type_id'.freeze => _abroad_no_activity} }
    when _general_active_foreign_traveller
      {'customer_calls_generation_params_own_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_region_active_caller}, 
       'customer_calls_generation_params_home_region_filtr'.freeze => {'phone_usage_type_id'.freeze => _home_region_active_caller},
       'customer_calls_generation_params_own_country_filtr'.freeze => {'phone_usage_type_id'.freeze => _own_country_active_caller}, 
       'customer_calls_generation_params_abroad_filtr'.freeze => {'phone_usage_type_id'.freeze => _abroad_active_caller} }
    else
      raise(StandardError, ["Wrong general_phone_usage_type_id #{general_phone_usage_type_id}", _general_home_sitter, _general_active_foreign_traveller])
    end
  end
  
    
  def self.usage_pattern(usage_pattern_id)
    case usage_pattern_id.to_i
    when _general_home_sitter
      {'share_of_time_in_own_region'.freeze => 1.00,'share_of_time_in_home_region'.freeze => 0.00,'share_of_time_in_own_country'.freeze => 0.0, 'share_of_time_abroad'.freeze => 0.00 }
    when _general_home_region_sitter
      {'share_of_time_in_own_region'.freeze => 0.75,'share_of_time_in_home_region'.freeze => 0.25,'share_of_time_in_own_country'.freeze => 0.0, 'share_of_time_abroad'.freeze => 0.00 }
    when _general_active_russia_traveller
      {'share_of_time_in_own_region'.freeze => 0.35,'share_of_time_in_home_region'.freeze => 0.15,'share_of_time_in_own_country'.freeze => 0.5, 'share_of_time_abroad'.freeze => 0.00 }
    when _general_active_foreign_traveller
      {'share_of_time_in_own_region'.freeze => 0.35,'share_of_time_in_home_region'.freeze => 0.15,'share_of_time_in_own_country'.freeze => 0.0, 'share_of_time_abroad'.freeze => 0.50 }

    when _own_region_active_caller
      {"number_of_day_calls".freeze => 10, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.2, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3 }
    when _own_region_active_sms
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 10, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.2, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3 }
    when _own_region_active_internet
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 2, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3 }
    when _home_region_active_caller
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.2, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _home_region_active_sms
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 10, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.2, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _home_region_active_internet
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 2.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _home_region_no_activity
      {"number_of_day_calls".freeze => 0, "duration_of_calls".freeze => 0, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 0, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _own_country_active_caller
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _own_country_active_sms
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 10, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _own_country_active_internet
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 2.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _own_country_no_activity
      {"number_of_day_calls".freeze => 0, "duration_of_calls".freeze => 0, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 0, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _abroad_active_caller
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day" => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _abroad_active_sms
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 10, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _abroad_active_internet
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 2.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    when _abroad_no_activity
      {"number_of_day_calls".freeze => 0, "duration_of_calls".freeze => 0, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day".freeze => 0, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 0.0, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    else
      {"number_of_day_calls".freeze => 1, "duration_of_calls".freeze => 5, "share_of_calls_to_other_mobile".freeze => 0.6, "share_of_calls_to_fix_line".freeze => 0.1,
      "share_of_regional_calls".freeze => 0.1, "share_of_international_calls".freeze => 0.00, "number_of_sms_per_day" => 1, "number_of_mms_per_day".freeze => 0, 
      "internet_trafic_per_month".freeze => 2, 'share_of_incoming_calls'.freeze => 0.5, 'share_of_incoming_calls_from_own_mobile'.freeze=> 0.3}
    end
  end

  module Helper
    def random(average)
      x = rand
      (x ** average) * Math.exp(-x) / Math.gamma(average)
#      Math.exp(average * (Math.exp(x) - 1.0))
#      pi = 3.1415926535897932384626433832#BigMath.PI(10)
#      if x < 0.25
#        Math.sin(x * average * pi) * average
#      else
#        average * 2.0 + Math.sin((x - 3.0/4.0) * pi) * average 
#      end
    end
    
  end
  
end
