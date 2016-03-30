class Optimization::Global::Base
  class CallGroup
    attr_reader :f
    
    def initialize
      @f = CallFields.new
    end
    
    def test(method)
      Customer::Call.where(:call_run_id => 553).where(send(method.to_sym)).count
    end
    
    def group(method_symbols = [])
      return "true" if method_symbols.compact.blank?
      group_fields(method_symbols).join(", ")
    end
    
    def group_fields(method_symbols = [])
      return [] if method_symbols.compact.blank?
      fields(method_symbols)
    end
    
    def fields_with_name(method_symbols = [])
      return "" if method_symbols.compact.blank?
      f.fields_with_name(fields(method_symbols))
    end
    
    def fields(method_symbols = [])
      method_symbols.compact.map{|method_symbol| send(method_symbol)}.flatten.uniq
    end

    def russia; [f.connect_country_id]; end
    def abroad_countries; [f.connect_country_id]; end

    def own_region; [f.connect_country_id, f.connect_region_id]; end
    def home_regions; [f.connect_country_id, f.connect_region_id]; end
    def own_and_home_regions; [f.connect_country_id, f.connect_region_id]; end
    def own_country_regions; [f.connect_country_id, f.connect_region_id]; end
    def any_region; []; end

    def calls_in; [f.base_service_id, f.base_subservice_id]; end
    def calls_out; [f.base_service_id, f.base_subservice_id]; end
    def sms_in; [f.base_service_id, f.base_subservice_id]; end
    def sms_out; [f.base_service_id, f.base_subservice_id]; end
    def mms_in; [f.base_service_id, f.base_subservice_id]; end
    def mms_out; [f.base_service_id, f.base_subservice_id]; end
    def internet; [f.base_service_id]; end

    def to_own_region; [f.partner_region_id]; end
    def to_home_regions; [f.partner_region_id]; end
    def to_own_and_home_regions; [f.partner_region_id]; end
    def to_own_country_regions; [f.partner_region_id]; end
    def to_abroad; [f.partner_country_id]; end
    def to_abroad_countries; [f.partner_country_id]; end
    def to_russia; [f.partner_country_id]; end
    def to_rouming_country; [f.partner_country_id, f.connect_country_id]; end
    def to_other_countries; [f.partner_country_id, f.connect_country_id]; end
#    def from_any_location; []; end

    def to_operators; [f.partner_operator_id]; end
#    def from_operators; [f.partner_operator_id]; end
#    def to_fix_line; [f.partner_operator_id, f.partner_operator_type_id]; end
    
  end

end
