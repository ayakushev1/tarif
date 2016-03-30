module Comparison::GroupPresenter
  def self.result_description(group_ids = [])
    result = {}
    tarifs = []; operators = [];
    Comparison::Group.where(:id => group_ids).each do |group|
      group.result['place'].values.each do |place| 
        tarifs << place['tarif_id'] 
        operators << place['operator_id']
      end if group.result and group.result['place']
    end
    
    tarifs_desc = {}
    TarifClass.where(:id => tarifs).each{|tarif| tarifs_desc[tarif.id] = tarif}

    operators_desc = {}
    Category.where(:id => operators).each{|operator| operators_desc[operator.id] = operator.name}
    
    Comparison::Group.where(:id => group_ids).each do |group|
      result[group.id] = {}
      group.result['place'].collect do |place, detail|
        next if detail.blank?
        result[group.id][place.to_i] = {
          :operator_name => operators_desc[detail['operator_id']],
          :tarif => tarifs_desc[detail['tarif_id']],
          :price => detail['price'],
          :group_name => group.name,
          :optimization_slug => group.optimization.slug
        }
      end if group.result and group.result['place']      
    end
    result
  end
  
end

