class ServiceHelper::QueryConstructor1
  include ::ParameterHelper
  attr_reader :context, :parameters, :criteria_where_hash, :criteria_category, :categories_where_hash,
              :tarif_classes_categories_where_hash, :category_groups_where_hash
  attr_reader :comparison_operators, :categories, :childs_category, :tarif_class_categories, :category_groups, 
              :options, :tarif_class_ids, :criterium_ids, :category_ids, :service_priorities, :call_ids_by_tarif_class_id, :bench
  
  def initialize(context, options = {})
    @context = context
    @options = options
    @tarif_class_ids = options[:tarif_class_ids]
    @criterium_ids = options[:criterium_ids]
    last = Time.now; @bench = {:start => Time.now - last}; start = last
    load_comparison_operators; @bench[:load_comparison_operators] = ((Time.now - last)*1000).round; last = Time.now
    load_category_ids; @bench[:load_category_ids] = ((Time.now - last)*1000).round; last = Time.now
    load_required_service_category_tarif_class_ids; @bench[:load_required_service_category_tarif_class_ids] = ((Time.now - last)*1000).round; last = Time.now
    load_service_priorities; @bench[:load_service_priorities] = ((Time.now - last)*1000).round; last = Time.now
    load_category_groups; @bench[:load_category_groups] = ((Time.now - last)*1000).round; last = Time.now
    load_service_categories; @bench[:load_service_categories] = ((Time.now - last)*1000).round; last = Time.now
    load_service_criteria      ; @bench[:load_service_criteria] = ((Time.now - last)*1000).round; last = Time.now
    load_parameters(options[:parameter_ids]); @bench[:load_parameters] = ((Time.now - last)*1000).round; last = Time.now
    
    calculate_service_criteria_where_hash; @bench[:calculate_service_criteria_where_hash] = ((Time.now - last)*1000).round; last = Time.now
    calculate_service_categories_where_hash; @bench[:calculate_service_categories_where_has] = ((Time.now - last)*1000).round; last = Time.now
    calculate_tarif_classes_categories_where_hash; @bench[:calculate_tarif_classes_categories_where_hash] = ((Time.now - last)*1000).round; last = Time.now
    calculate_call_ids_by_tarif_class_id; @bench[:calculate_call_ids_by_tarif_class_id] = ((Time.now - last)*1000).round; last = Time.now
    calculate_category_groups_where_hash; @bench[:calculate_category_groups_where_hash] = ((Time.now - last)*1000).round; last = Time.now
    @bench[:total] = ((start - last)*1000).round
  end
  
  def calculate_stat(output_model, filtr_and_input_to_not_stat_fields, stat_functions = {'count' => 'count(id)'})
    input = []
    tarif_classes_categories_where_hash.each do |key, tcc|
      if tcc
        current_tarif_class_id = tarif_class_categories[key].tarif_class_id
        stat_sql_hash = {'tarif_class_service_category_id' => key, 'tarif_class_id' => current_tarif_class_id }                   
        id_from_tarif_class_id_list_where_condition = "(id = any('{#{call_ids_by_tarif_class_id[current_tarif_class_id].join(', ')}}') )"
        
        stat_functions.each do |stat_key, stat_function| 
          stat_sql_hash[stat_key] = "select #{stat_function} from customer_calls where #{tcc} and #{id_from_tarif_class_id_list_where_condition}" 
        end
        input << filtr_and_input_to_not_stat_fields.merge(:result => stat_sql_hash ) 
      end
    end

#      output_model.delete_all        
    output_model.where(filtr_and_input_to_not_stat_fields).delete_all        
    output_model.pg_json_create(input)
    
    output_model.where(filtr_and_input_to_not_stat_fields).each do |row|
      row.update(filtr: tarif_classes_categories_where_hash[row[:result]['key'].to_s ])
    end
  end
  
  def calls_count
    Customer::Call.where(tarif_classes_where_hash).count
  end
  
  def calculate_call_ids_by_tarif_class_id
    @call_ids_by_tarif_class_id = []
    accumulated_call_ids = []
    service_priorities.compact.each do |sp|
      call_ids_by_tarif_class_id[sp.main_tarif_class_id] = Customer::Call.where(tarif_class_where_hash(sp.main_tarif_class_id) ).
        where.not(:id => accumulated_call_ids ).pluck(:id)
      accumulated_call_ids += call_ids_by_tarif_class_id[sp.main_tarif_class_id]
    end
  end
  
  def tarif_classes_where_hash
    where = ["false"]
    tarif_class_ids.each { |tarif_class_id| where << "( #{tarif_class_where_hash(tarif_class_id)} )" }
    where.join(' or ')
  end
  
  def tarif_class_where_hash(tarif_class_id)
    where = ["false"]
    tarif_classes_categories_where_hash.each { |key, tcc| where << "( #{tcc} )" if tcc and tarif_class_categories[key].tarif_class_id == tarif_class_id }
    where.join(' or ')
  end
  
  def tarif_classes_category_where_hash(tarif_classes_category_id)
    tcc = tarif_class_categories[tarif_classes_category_id.to_s]
    tcc ? tarif_classes_categories_where_hash[tcc.id.to_s] : nil
  end
  
  def calculate_category_groups_where_hash      
    @category_groups_where_hash = {}
    category_groups.each do |category_group_id, category_group|
      category_groups_where_hash[category_group_id] = category_group.criteria.
        collect { |category_id, category|  categories_where_hash[category_id.to_i] }.compact.join(' and ') 
    end
  end
  
  def calculate_tarif_classes_categories_where_hash
    @tarif_classes_categories_where_hash = {}
    tarif_class_categories.each {|key, value| tarif_classes_categories_where_hash[value[:id].to_s] = initial_tarif_classes_category_where_hash(value)}
  end
  
  def initial_tarif_classes_category_where_hash(tarif_classes_category)
    t = tarif_classes_category
    [t.service_category_rouming_id, t.service_category_geo_id, t.service_category_partner_type_id, 
    t.service_category_calls_id, t.service_category_one_time_id, t.service_category_periodic_id].
      collect { |category_id| category_id ? categories_where_hash[category_id] : true }.compact.join(' and ')
  end
  
  def calculate_service_categories_where_hash
    @categories_where_hash = []

    Service::Category.where(:id => category_ids).order(:level).where(:parent_id => nil).each do |c|      
      (childs_category[c.id] << c.id).each do |cat_id|
        categories_where_hash[cat_id] = correct_category_criteria(cat_id).compact.join(' and ')
        categories_where_hash[cat_id] = 'true' if categories_where_hash[cat_id].blank?
      end   
    end
  end
  
  def correct_category_criteria(category_id)
    (parents_category_criteria(category_id) || [] ) +
    (category_criteria_stand_alone(category_id) || [] ) +
    (childs_category_criteria(category_id) || [])
  end

  def parents_category_criteria(category_id)
    categories[category_id].path.collect {|cat_id| category_criteria_stand_alone(cat_id) } if categories[category_id] and categories[category_id].path
  end

  def category_criteria_stand_alone(category_id)      
    criteria_category[category_id].collect {|crit_id| criteria_where_hash[crit_id]} if criteria_category[category_id]
  end

  def childs_category_criteria(category_id)
    childs_category[category_id].collect {|cat_id| category_criteria_stand_alone(cat_id) } if childs_category[category_id]
  end

  def calculate_childs_category
    categories.each { |c| add_child_category(c.id, c.parent_id) if c and c.parent_id }
  end
  
  def add_child_category(child_id, parent_id)
    childs_category[parent_id] = [] if childs_category[parent_id].blank?
    childs_category[parent_id] << child_id
    add_child_category(child_id, categories[parent_id].parent_id) if categories[parent_id] and categories[parent_id].parent_id
  end
  
  def calculate_service_criteria_where_hash
    @criteria_where_hash = []
    crit = criterium_ids ? Service::Criterium.where(:id => criterium_ids) : Service::Criterium.all
    crit.each { |c| criteria_where_hash[c.id] = criterium_where_hash(c)}
  end
  
  def criterium_where_hash(criterium)
    criteria_param = parameter_class_sql_name(parameters[criterium.criteria_param_id], context)

    comparison_operator = comparison_operators[criterium.comparison_operator_id]
    
    value_param = criterium.value
    value_param = parameter_class_instance_value(parameters[criterium.value_param_id], context, criterium.value) if criterium.value_param_id      
    value_param = eval(criterium.eval_string) if criterium.eval_string
    
    case comparison_operator
    when 'in'
      "(#{criteria_param} = any('{#{value_param.join(', ')}}') )"
    when 'not_in'
      "(#{criteria_param} != all('{#{value_param.join(', ')}}') )"
    else
      "(#{criteria_param} #{comparison_operator} '#{value_param}')"
    end      
  end
      
  def load_parameters(parameter_ids = nil)
    @parameters = []
    pars = parameter_ids ? Parameter.where(:id => parameter_ids) : Parameter.all
    pars.each { |p| parameters[p.id] = p }
  end
  
  def load_service_criteria
    @criteria_category = []
    crit = criterium_ids ? Service::Criterium.where(:id => criterium_ids) : Service::Criterium.all
    crit.each do |c| 
      criteria_category[c.service_category_id] = [] if criteria_category[c.service_category_id].blank?
      criteria_category[c.service_category_id] << c.id
    end
  end
  
  def load_service_categories
    @categories = []; @childs_category = [];      
    Service::Category.where(:id => category_ids).order(:level).each { |c| categories[c.id] = c }  
    calculate_childs_category      
  end
  
  def load_service_priorities
    @service_priorities = []
    Service::Priority.general_priority.where(:main_tarif_class_id => tarif_class_ids).order(value: :desc).
      each { |sp| service_priorities[sp.main_tarif_class_id] = sp}
  end
  
  def load_category_groups
    @category_groups = {}
    category_group_ids = Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.where.not(:as_standard_category_group_id => nil).
    pluck(:as_standard_category_group_id).uniq
    
    Service::CategoryGroup.where(:id => category_group_ids).each do |st|
      category_groups[st.id.to_s] = st
    end
  end
  
  def load_required_service_category_tarif_class_ids
    @tarif_class_categories = {}
    Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.#original.
      uniq.each {|ctc| tarif_class_categories[ctc.id.to_s] = ctc }        
  end
  
  def load_category_ids
#      service_category_ids = Service::CategoryTarifClass.service_category_ids(tarif_class_ids)
    @category_ids = Service::Category.pluck(:id)#where(:id => service_category_ids).pluck(:path).slice(0)
    
  end
  
  def load_comparison_operators
    @comparison_operators = []
    ::Category.comparison_operators.each { |o| comparison_operators[o.id] = o.name }
  end
  
end
  
