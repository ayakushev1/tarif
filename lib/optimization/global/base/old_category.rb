class Optimization::Global::Base
  class Category
    attr_reader :f, :tarif_country_id, :tarif_region_id, :tarif_operator_id, :tarif_home_region_ids, :tarif_own_and_home_region_ids
  
    def initialize(options = {})
      @f = CallFields.new
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

    def calls_in; "#{f.base_service_id} = #{Category::BaseService::Call} and #{f.base_subservice_id} = #{Category::ServiceDirection::Inbound}"; end
    def calls_out; "#{f.base_service_id} = #{Category::BaseService::Call} and #{f.base_subservice_id} = #{Category::ServiceDirection::Outbound}"; end
    def sms_in; "#{f.base_service_id} = #{Category::BaseService::Sms} and #{f.base_subservice_id} = #{Category::ServiceDirection::Inbound}"; end
    def sms_out; "#{f.base_service_id} = #{Category::BaseService::Sms} and #{f.base_subservice_id} = #{Category::ServiceDirection::Outbound}"; end
    def mms_in; "#{f.base_service_id} = #{Category::BaseService::Mms} and #{f.base_subservice_id} = #{Category::ServiceDirection::Inbound}"; end
    def mms_out; "#{f.base_service_id} = #{Category::BaseService::Mms} and #{f.base_subservice_id} = #{Category::ServiceDirection::Outbound}"; end
    def internet; "#{f.base_service_id} = any('{#{Category::BaseService::Internet.join(', ')}}')"; end

    def to_own_region; [tarif_region_id]; end
    def to_home_regions; tarif_home_region_ids; end
    def to_own_and_home_regions; tarif_own_and_home_region_ids; end
    def to_own_country_regions; Category::Region::Const::Regions - tarif_own_and_home_region_ids; end
    def to_abroad; Category::Country::Const::All_countries - russia; end
    def to_abroad_countries; "#{f.partner_country_id} != #{tarif_country_id}"; end
    def to_russia; "#{f.partner_country_id} = #{tarif_country_id}"; end
    def to_rouming_country; "#{f.partner_country_id} = #{f.connect_country_id}"; end
    def to_other_countries; "not (#{to_russia} or #{to_rouming_country})"; end
    def from_any_location; "true"; end

    def to_operators; "true"; end
    def from_operators; "true"; end
    def to_fix_line; "#{f.partner_operator_type_id} = #{Category::OperatorType::Fixed_line}"; end

  end
end
