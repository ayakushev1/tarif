class Optimization::GlobalCategory
  attr_reader :call_filtr, :call_group
  
  def initialize(options = {})
    @call_filtr = CallFiltr.new(options)
    @call_group = CallGroup.new
  end
  
  def test
    calls = Customer::Call.where(:call_run_id => 553)
    stat_params = ["count(*) as call_id_count"]
    stat_by_category(calls, stat_params)
  end
  
  def stat_by_category(calls, stat_params)
    result = []
    iterate do |rouming_country, rouming_region, service, destination, partner, final_category|
      params = [rouming_country, rouming_region, service, destination, partner].compact
      cat_name = "'#{params.map(&:to_s).join("_")}' as global_name"
      fields = [[cat_name] + call_group.fields_with_name(params) + stat_params].join(", ")
      where_hash = call_filtr.filtr(params)
      group_by = call_group.group(params)
      result << calls.select(fields).where(where_hash).group(group_by)
    end
    result
  end
  
  def items
    result = []
    iterate do |rouming_country, rouming_region, service, destination, partner, final_category|
      result << [rouming_country, rouming_region, service, try(:destination), try(:partner)]
    end
    result
  end
  
  def iterate
    Structure.each do |rouming_country, cat_by_rouming_country|
      cat_by_rouming_country.each do |rouming_region, cat_by_rouming_region|
        cat_by_rouming_region.each do |service, cat_by_service|
          if cat_by_service.blank?
            yield [rouming_country, rouming_region, service, nil, nil, cat_by_service]
          else
            cat_by_service.each do |destination, cat_by_destination|
              if cat_by_destination.blank?
                yield [rouming_country, rouming_region, service, destination, nil, cat_by_destination]
              else
                cat_by_destination.each do |partner, cat_by_partner|
                  yield [rouming_country, rouming_region, service, destination, partner, cat_by_partner]
                end                
              end
            end
          end
        end        
      end      
    end
  end
  
  class CallFiltr
    attr_reader :tarif_country_id, :tarif_region_id, :tarif_operator_id, :tarif_home_region_ids, :tarif_own_and_home_region_ids
  
    def initialize(options = {})
      @tarif_country_id = options[:tarif_country_id] || 1100
      @tarif_region_id = options[:tarif_region_id] || 1238
      @tarif_home_region_ids = options[:tarif_home_region_ids] || [1127]
      @tarif_own_and_home_region_ids = @tarif_home_region_ids + [@tarif_region_id]
    end

    def test(method)
      Customer::Call.where(:call_run_id => 553).where(send(method.to_sym)).count
    end
    
    def filtr(method_symbols = [])
      return "true" if method_symbols.compact.blank?
      method_symbols.compact.map{|method_symbol| "(#{send(method_symbol)})"}.join(" and ")
    end
    
    def russia; "(connect->>'country_id')::int = #{tarif_country_id}"; end
    def abroad_countries; "(connect->>'country_id')::int != #{tarif_country_id}"; end

    def own_region; "(connect->>'region_id')::int = #{tarif_region_id}"; end
    def home_regions; "(connect->>'region_id')::int = any('{#{tarif_home_region_ids.join(', ')}}')"; end
    def own_and_home_regions; "(connect->>'region_id')::int = any('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def own_country_regions; "#{russia} and (connect->>'region_id')::int != all('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def any_region; "true"; end

    def calls_in; "base_service_id = #{::Category::BaseService::Call} and base_subservice_id = #{::Category::ServiceDirection::Inbound}"; end
    def calls_out; "base_service_id = #{::Category::BaseService::Call} and base_subservice_id = #{::Category::ServiceDirection::Outbound}"; end
    def sms_in; "base_service_id = #{::Category::BaseService::Sms} and base_subservice_id = #{::Category::ServiceDirection::Inbound}"; end
    def sms_out; "base_service_id = #{::Category::BaseService::Sms} and base_subservice_id = #{::Category::ServiceDirection::Outbound}"; end
    def mms_in; "base_service_id = #{::Category::BaseService::Mms} and base_subservice_id = #{::Category::ServiceDirection::Inbound}"; end
    def mms_out; "base_service_id = #{::Category::BaseService::Mms} and base_subservice_id = #{::Category::ServiceDirection::Outbound}"; end
    def internet; "base_service_id = any('{#{::Category::BaseService::Internet.join(', ')}}')"; end

    def to_own_region; "(partner_phone->>'region_id')::int = #{tarif_region_id}"; end
    def to_home_regions; "(partner_phone->>'region_id')::int = any('{#{tarif_home_region_ids.join(', ')}}')"; end
    def to_own_and_home_regions; "(partner_phone->>'region_id')::int = any('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def to_own_country_regions; "#{russia} and (partner_phone->>'region_id')::int != all('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def to_abroad; "(partner_phone->>'country_id')::int != #{tarif_country_id}"; end
    def to_abroad_countries; "(partner_phone->>'country_id')::int != #{tarif_country_id}"; end
    def to_russia; "(partner_phone->>'country_id')::int = #{tarif_country_id}"; end
    def to_rouming_country; "(partner_phone->>'country_id')::int = (connect->>'country_id')::int"; end
    def to_other_countries; "not (#{to_russia} and #{to_rouming_country})"; end

    def to_operators; "true"; end
    def to_mobile_operators; "(partner_phone->>'operator_type_id')::int = #{::Category::OperatorType::Mobile}"; end
    def to_fix_line; "(partner_phone->>'operator_type_id')::int = #{::Category::OperatorType::Fixed_line}"; end

  end
  
  class CallGroup
    def test(method)
      Customer::Call.where(:call_run_id => 553).where(send(method.to_sym)).count
    end
    
    def group(method_symbols = [])
      return "true" if method_symbols.compact.blank?
      fields(method_symbols).join(", ")
    end
    
    def fields_with_name(method_symbols = [])
      return "" if method_symbols.compact.blank?
      method_symbols.compact.map{|method_symbol| send(method_symbol)}.flatten.uniq.map{|field| "#{field} as #{name_by_field(field)}"}
    end
    
    def name_by_field(field)
      case field
      when base_service_id; "base_service_id"
      when base_subservice_id; "base_subservice_id"
      when connect_country_id; "connect_country_id"
      when connect_region_id; "connect_region_id"
      when partner_country_id; "partner_country_id"
      when partner_region_id; "partner_region_id"
      when partner_operator_type_id; "partner_operator_type_id"        
      end
    end

    def fields(method_symbols = [])
      method_symbols.compact.map{|method_symbol| send(method_symbol)}.flatten.uniq
    end

    def russia; [connect_country_id]; end
    def abroad_countries; [connect_country_id]; end

    def own_region; [connect_region_id]; end
    def home_regions; [connect_region_id]; end
    def own_and_home_regions; [connect_region_id]; end
    def own_country_regions; [connect_region_id]; end
    def any_region; []; end

    def calls_in; [base_service_id, base_subservice_id]; end
    def calls_out; [base_service_id, base_subservice_id]; end
    def sms_in; [base_service_id, base_subservice_id]; end
    def sms_out; [base_service_id, base_subservice_id]; end
    def mms_in; [base_service_id, base_subservice_id]; end
    def mms_out; [base_service_id, base_subservice_id]; end
    def internet; [base_service_id]; end

    def to_own_region; [partner_region_id]; end
    def to_home_regions; [partner_region_id]; end
    def to_own_and_home_regions; [partner_region_id]; end
    def to_own_country_regions; [partner_region_id]; end
    def to_abroad; [partner_country_id]; end
    def to_abroad_countries; [partner_country_id]; end
    def to_russia; [partner_country_id]; end
    def to_rouming_country; [partner_country_id, connect_country_id]; end
    def to_other_countries; [partner_country_id, connect_country_id]; end

    def to_operators; []; end
    def to_mobile_operators; [partner_operator_type_id]; end
    def to_fix_line; [partner_operator_type_id]; end
    
    def base_service_id; "base_service_id".freeze; end
    def base_subservice_id; "base_subservice_id".freeze; end
    def connect_country_id; "(connect->>'country_id')::int".freeze; end
    def connect_region_id; "(connect->>'region_id')::int".freeze; end
    
    def partner_country_id; "(partner_phone->>'country_id')::int".freeze; end
    def partner_region_id; "(partner_phone->>'region_id')::int".freeze; end
    
    def partner_operator_type_id; "(partner_phone->>'operator_type_id')::int".freeze; end

  end
  
  class Category
    attr_reader :tarif_country_id, :tarif_region_id, :tarif_operator_id, :tarif_home_region_ids, :tarif_own_and_home_region_ids
  
    def initialize(options = {})
      @tarif_country_id = options[:tarif_country_id] || 1100
      @tarif_region_id = options[:tarif_region_id] || 1238
      @tarif_home_region_ids = options[:tarif_home_region_ids] || [1127]
      @tarif_own_and_home_region_ids = @tarif_home_region_ids + [@tarif_region_id]
    end

    def russia; [Category::Country::Const::Russia]; end
    def abroad_countries; Category::Country::Const::All_countries - russia; end

    def own_region; [tarif_region_id]; end
    def home_regions; tarif_home_region_ids; end
    def own_country_regions; Category::Region::Const::Regions - tarif_own_and_home_region_ids; end
    def any_region; [-1]; end

    def calls_in; "base_service_id = #{Category::BaseService::Call} and base_subservice_id = #{Category::ServiceDirection::Inbound}"; end
    def calls_out; "base_service_id = #{Category::BaseService::Call} and base_subservice_id = #{Category::ServiceDirection::Outbound}"; end
    def sms_in; "base_service_id = #{Category::BaseService::Sms} and base_subservice_id = #{Category::ServiceDirection::Inbound}"; end
    def sms_out; "base_service_id = #{Category::BaseService::Sms} and base_subservice_id = #{Category::ServiceDirection::Outbound}"; end
    def mms_in; "base_service_id = #{Category::BaseService::Mms} and base_subservice_id = #{Category::ServiceDirection::Inbound}"; end
    def mms_out; "base_service_id = #{Category::BaseService::Mms} and base_subservice_id = #{Category::ServiceDirection::Outbound}"; end
    def internet; "base_service_id = any('{#{Category::BaseService::Internet.join(', ')}}')"; end

    def to_own_region; [tarif_region_id]; end
    def to_home_regions; tarif_home_region_ids; end
    def to_own_and_home_regions; tarif_own_and_home_region_ids; end
    def to_own_country_regions; Category::Region::Const::Regions - tarif_own_and_home_region_ids; end
    def to_abroad; Category::Country::Const::All_countries - russia; end
    def to_abroad_countries; "(partner_phone->>'country_id')::int != #{tarif_country_id}"; end
    def to_russia; "(partner_phone->>'country_id')::int = #{tarif_country_id}"; end
    def to_rouming_country; "(partner_phone->>'country_id')::int = (connect->>'country_id')::int"; end
    def to_other_countries; "not (#{to_russia} and #{to_rouming_country})"; end

    def to_operators; "true"; end
    def to_mobile_operators; "(partner_phone->>'operator_type_id')::int = #{Category::OperatorType::Mobile}"; end
    def to_fix_line; "(partner_phone->>'operator_type_id')::int = #{Category::OperatorType::Fixed_line}"; end

  end
  
  Structure = {
    :russia => {
      :own_and_home_regions => {
        :calls_in => {},
        :calls_out => {
          :to_own_and_home_regions => {:to_mobile_operators => {}, :to_fix_line => {}},
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
        :calls_in => {},
        :calls_out => {
          :to_own_and_home_regions => {:to_operators => {}},
          :to_own_country_regions => {:to_operators => {}},
          :to_abroad_countries => {:to_operators => {}}
        },
        :sms_in => {},
        :sms_out => {:to_russia => {}, :to_abroad => {}},
        :mms_in => {},
        :mms_out => {},
        :internet =>{}
      }
    },
    :abroad_countries => {
      :any_region => {
        :calls_in => {},
        :calls_out => {:to_russia => {}, :to_rouming_country => {}, :to_other_countries => {}},
        :sms_in => {},
        :sms_out => {},
        :mms_in => {},
        :mms_out => {},
        :internet =>{}
      }
    }
  }
  
end
