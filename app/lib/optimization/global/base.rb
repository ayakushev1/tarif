class Optimization::Global::Base
  attr_reader :f, :call_filtr, :call_group, :category_filtr, :structure_name
  
  def initialize(options = {})
    @f = CallFields.new
    @call_filtr = CallFiltr.new(options)
    @call_group = CallGroup.new
    @category_filtr = CategoryFiltr.new
    @structure_name = StructureName.new
  end
  
  def items
    result = []
    iterate do |rouming_country, rouming_region, service, destination, partner, final_category|
      result << [rouming_country, rouming_region, service, destination, partner]
    end
    result
  end
  
  def iterate
    Structure.each do |rouming_country, cat_by_rouming_country|
      cat_by_rouming_country.each do |rouming_region, cat_by_rouming_region|
        if cat_by_rouming_region.blank?
          yield [rouming_country, rouming_region, nil, nil, nil, cat_by_rouming_region]
        else
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
  end
  
end
