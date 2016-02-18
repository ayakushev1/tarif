class Optimization::Global::Base  
  class CallFiltr
    attr_reader :f, :tarif_country_id, :tarif_region_id, :tarif_operator_id, :tarif_home_region_ids, :tarif_own_and_home_region_ids
  
    def initialize(options = {})
      @f = CallFields.new
      @tarif_country_id = options[:tarif_country_id] || 1100
      @tarif_region_id = options[:tarif_region_id] || 1238
      @tarif_home_region_ids = options[:tarif_home_region_ids] || [1127]
      @tarif_own_and_home_region_ids = @tarif_home_region_ids + [@tarif_region_id]
    end

    def test(method)
      Customer::Call.where(:call_run_id => 553).where(send(method.to_sym))#.count
    end

    def test_1(methods = [])
      methods = [:russia, :own_country_regions, :calls_in, :from_any_location, :from_operators] if methods.blank?
      Customer::Call.where(:call_run_id => 553).where(filtr(methods)).to_sql#.count
    end
#         => { => {}, :to_rouming_country => {}, :to_other_countries => {}},
    
    def filtr(method_symbols = [])
      return "true" if method_symbols.compact.blank?
      method_symbols.compact.map{|method_symbol| "(#{send(method_symbol)})"}.join(" and ".freeze)
    end
    
    def russia; "#{f.connect_country_id} = #{tarif_country_id}"; end
    def abroad_countries; "#{f.connect_country_id} != #{tarif_country_id}"; end

    def own_region; "#{russia} and #{f.connect_region_id} = #{tarif_region_id}"; end
    def home_regions; "#{russia} and #{f.connect_region_id} = any('{#{tarif_home_region_ids.join(', ')}}')"; end
    def own_and_home_regions; "#{russia} and #{f.connect_region_id} = any('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def own_country_regions; "#{russia} and #{f.connect_region_id} != all('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def any_region; "true"; end

    def calls_in; "#{f.base_service_id} = #{::Category::BaseService::Call} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Inbound}"; end
    def calls_out; "#{f.base_service_id} = #{::Category::BaseService::Call} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Outbound}"; end
    def sms_in; "#{f.base_service_id} = #{::Category::BaseService::Sms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Inbound}"; end
    def sms_out; "#{f.base_service_id} = #{::Category::BaseService::Sms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Outbound}"; end
    def mms_in; "#{f.base_service_id} = #{::Category::BaseService::Mms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Inbound}"; end
    def mms_out; "#{f.base_service_id} = #{::Category::BaseService::Mms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Outbound}"; end
    def internet; "#{f.base_service_id} = any('{#{::Category::BaseService::Internet.join(', ')}}')"; end

    def to_own_region; "#{f.partner_region_id} = #{tarif_region_id}"; end
    def to_home_regions; "#{f.partner_region_id} = any('{#{tarif_home_region_ids.join(', ')}}')"; end
    def to_own_and_home_regions; "#{f.partner_region_id} = any('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def to_own_country_regions; "#{russia} and #{f.partner_region_id} != all('{#{tarif_own_and_home_region_ids.join(', ')}}')"; end
    def to_abroad; "#{f.partner_country_id} != #{tarif_country_id}"; end
    def to_abroad_countries; "#{f.partner_country_id} != #{tarif_country_id}"; end
    def to_russia; "#{f.partner_country_id} = #{tarif_country_id}"; end
    def to_rouming_country; "#{f.partner_country_id} = #{f.connect_country_id}"; end
    def to_other_countries; "not ((#{to_russia}) or (#{to_rouming_country}))"; end
#    def from_any_location; "true"; end

    def to_operators; "true"; end
#    def from_operators; "true"; end
#    def to_fix_line; "#{f.partner_operator_type_id} = #{::Category::OperatorType::Fixed_line}"; end

  end

end
