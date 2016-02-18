class Optimization::Global::Base
  class StructureName
    def test
        result = {0 => {}, 1 => {}}
        Service::CategoryTarifClass.
        includes(:service_category_rouming, :service_category_calls, :service_category_geo, :service_category_partner_type).
        select("*, service_category_tarif_classes.name as name1").each do |row|
          categories = []
          [:service_category_rouming, :service_category_calls, :service_category_geo, :service_category_partner_type].each do |cat|
            categories << row.send(cat).global if row.send(cat)
          end
          next if categories.blank?
          begin
            name(categories.compact)
          rescue StandardError => e
            raise(StandardError, [categories, e]) if e.message.split("'").size > 1
            err =  eval(e.message)
            result[err[0]][err[1]] ||= {} 
            result[err[0]][err[1]]['cat'] = err[2]
            result[err[0]][err[1]][row.tarif_class_id] ||= []
            result[err[0]][err[1]][row.tarif_class_id] << [row.id, row.name1]
          end
        end
        result
    end    
    
    def params_from_name(global_name)
      result = global_name.split("/").map(&:to_sym)
      result[2] = :to_abroad_countries if [[:own_and_home_regions, :sms_out, :to_abroad], [:own_country_regions, :sms_out, :to_abroad]].include?(result)
      result
    end
    
    def name(categories)
      return nil if categories.blank?
      result = []
      current_structure = Structure
      categories.map(&:to_sym).each do |category|
        if current_structure.include?(category)
          result << send(category) 
          current_structure = current_structure[category]
        else
          break if current_structure.blank?
          if category == :to_abroad_countries
            result << send(:to_abroad) 
            current_structure = current_structure[:to_abroad]
            break
          end
#          return nil
          raise(StandardError, [0, categories.join('/'), category, "wrong global category"])# #{category} in #{categories}"])
        end
      end
      while !current_structure.blank?
        if current_structure.keys.size == 1
          category = current_structure.keys[0]
          result << send(category) 
          current_structure = current_structure[category]
        else
#          return nil
          raise(StandardError, [1, categories.join('/'), category, "not enough categories to choose global category from "])##{categories}"])
        end
      end 
      result.join('/')
    end
    
#    def russia; 'russia'; end
    def abroad_countries; 'abroad_countries'; end

#    def own_region; [f.connect_country_id, f.connect_region_id]; end
#    def home_regions; [f.connect_country_id, f.connect_region_id]; end
    def own_and_home_regions; 'own_and_home_regions'; end
    def own_country_regions; 'own_country_regions'; end
#    def any_region; []; end

    def calls_in; 'calls_in'; end
    def calls_out; 'calls_out'; end
    def sms_in; 'sms_in'; end
    def sms_out; 'sms_out'; end
    def mms_in; 'mms_in'; end
    def mms_out; 'mms_out'; end
    def internet; 'internet'; end

#    def to_own_region; [f.partner_region_id]; end
#    def to_home_regions; [f.partner_region_id]; end
    def to_own_and_home_regions; 'to_own_and_home_regions'; end
    def to_own_country_regions; 'to_own_country_regions'; end
    def to_abroad; 'to_abroad'; end
    def to_abroad_countries; 'to_abroad_countries'; end
    def to_russia; 'to_russia'; end
    def to_rouming_country; 'to_rouming_country'; end
    def to_other_countries; 'to_other_countries'; end
#    def from_any_location; []; end

    def to_operators; 'to_operators'; end
#    def from_operators; 'from_operators'; end
#    def to_fix_line; [f.partner_operator_id, f.partner_operator_type_id]; end
    
  end

end
