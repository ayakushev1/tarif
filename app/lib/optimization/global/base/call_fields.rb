class Optimization::Global::Base
  class CallFields
    def fields_with_name(fields_to_calculate)
      all_fields.map do |field|
        fields_to_calculate.include?(field) ? "#{field} as #{name_by_field(field)}" : "-1::int as #{name_by_field(field)}"
      end
#      method_symbols.compact.map{|method_symbol| send(method_symbol)}.flatten.uniq.map{|field| "#{field} as #{name_by_field(field)}"}
    end
    
    def all_fields
      [base_service_id, base_subservice_id, connect_country_id, connect_region_id, partner_country_id, partner_region_id, partner_operator_id, partner_operator_type_id]
    end
    
    def name_by_field(field)
      case field
      when base_service_id; "base_service_id".freeze
      when base_subservice_id; "base_subservice_id".freeze
      when connect_country_id; "connect_country_id".freeze
      when connect_region_id; "connect_region_id".freeze
      when partner_country_id; "partner_country_id".freeze
      when partner_region_id; "partner_region_id".freeze
      when partner_operator_id; "partner_operator_id".freeze        
      when partner_operator_type_id; "partner_operator_type_id".freeze        
      end
    end

    def base_service_id; "base_service_id".freeze; end
    def base_subservice_id; "base_subservice_id".freeze; end
    def connect_country_id; "(connect->>'country_id')::int".freeze; end
    def connect_region_id; "(connect->>'region_id')::int".freeze; end
    
    def partner_country_id; "(partner_phone->>'country_id')::int".freeze; end
    def partner_region_id; "(partner_phone->>'region_id')::int".freeze; end
    
    def partner_operator_id; "(partner_phone->>'operator_id')::int".freeze; end
    def partner_operator_type_id; "(partner_phone->>'operator_type_id')::int".freeze; end
    
  end

end
