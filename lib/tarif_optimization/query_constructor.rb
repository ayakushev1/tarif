class TarifOptimization::QueryConstructor
  include ::ParameterHelper
  attr_reader :context, :parameters, :criteria_where_hash, :criteria_category, :categories_where_hash,
              :tarif_classes_categories_where_hash
  attr_reader :comparison_operators, :categories, :categories_as_hash, :childs_category, :tarif_class_categories, :category_groups, 
              :options, :tarif_class_ids, :criterium_ids, :category_ids,
              :tarif_class_categories_by_tarif_class, :tarif_class_categories_by_category_group, :service_category_group_ids_by_tarif_class
  attr_reader :performance_checker
  
  def initialize(context, options = {}, operator_id = nil, region_id = nil, if_to_load = true)
    @context = context
    @options = options
    @tarif_class_ids = options[:tarif_class_ids]
    @criterium_ids = options[:criterium_ids]
    @performance_checker = options[:performance_checker]
    load_or_calculate_query(operator_id, region_id, if_to_load)  
#    raise(StandardError)  
  end

  def load_or_calculate_query(operator_id, region_id, if_to_load)
    if_to_load ? load_query(operator_id, region_id) : calculate_query
  end
  
  def calculate_query
    load_comparison_operators
    load_category_ids
    load_required_service_category_tarif_class_ids
    load_service_category_tarif_class_ids_by_tarif_class
    load_service_category_group_ids_by_tarif_class
    load_category_groups
    load_service_categories
    load_service_criteria
    load_parameters(options[:parameter_ids])
    
    calculate_service_criteria_where_hash
    calculate_service_categories_where_hash
    calculate_tarif_classes_categories_where_hash      
  end
  
  def load_query(operator_id, region_id)
    query_constructor_saver = Customer::Stat::OptimizationResult.new('preloaded_calculations', 'query_constructor', nil)
    loaded_data = query_constructor_saver.results({:operator_id => operator_id.to_i, :tarif_id => region_id.to_i})
    return calculate_query if loaded_data.blank?

    @comparison_operators = loaded_data['service_stat'] #array
    @categories = loaded_data['categories'] #array of AR
    @childs_category = loaded_data['childs_category'] #array of array of int

    @categories_as_hash = {}
    loaded_data['categories_as_hash'].each do |category_id, category_as_hash|
      @categories_as_hash[category_id.to_i] = category_as_hash
    end
    
    @tarif_class_categories = {}
    loaded_data['tarif_class_categories'].each do |tarif_class_category_id, tarif_class_category|
      @tarif_class_categories[tarif_class_category_id.to_i] = tarif_class_category
    end
    
    @tarif_class_categories_by_tarif_class = {}
    loaded_data['tarif_class_categories_by_tarif_class'].each do |tarif_class_id, tarif_class_category_by_tarif_class|
      @tarif_class_categories_by_tarif_class[tarif_class_id.to_i] = tarif_class_category_by_tarif_class
    end
    
    @tarif_class_categories_by_category_group = {}
    loaded_data['tarif_class_categories_by_category_group'].each do |category_group_id, tarif_class_category_by_category_group|
      @tarif_class_categories_by_category_group[category_group_id.to_i] = tarif_class_category_by_category_group
    end

    @service_category_group_ids_by_tarif_class = {}
    loaded_data['service_category_group_ids_by_tarif_class'].each do |tarif_class_id, service_category_group_id_by_tarif_class|
      @service_category_group_ids_by_tarif_class[tarif_class_id.to_i] = service_category_group_id_by_tarif_class
    end
    
    @category_groups = {}
    loaded_data['category_groups'].each do |category_group_id, category_group|
      @category_groups[category_group_id.to_i] = category_group
    end

    @category_ids = loaded_data['category_ids'.freeze] #array of int
  
    @parameters = loaded_data['parameters'] #array of AR
    @criteria_where_hash = loaded_data['criteria_where_hash'.freeze] #array of string
    @criteria_category = loaded_data['criteria_category'.freeze] #array of array of int
    @categories_where_hash = loaded_data['categories_where_hash'.freeze] #array of string

    @tarif_classes_categories_where_hash = {}
    loaded_data['tarif_classes_categories_where_hash'.freeze].each do |tarif_class_category_id, tarif_classes_category_where_hash|
      @tarif_classes_categories_where_hash[tarif_class_category_id.to_i] = tarif_classes_category_where_hash
    end
  end

  def tarif_class_where_hash(tarif_class_id)
    where = ["false".freeze]
    tarif_classes_categories_where_hash.each { |key, tcc| where << "( #{tcc} )" if tcc and tarif_class_categories[key]['tarif_class_id'.freeze] == tarif_class_id }
    where.join(' or '.freeze)
  end
  
  def joined_tarif_classes_category_where_hash(tarif_classes_category_ids)
    where = ["false"]
    tarif_classes_category_ids.each do |tarif_classes_category_id|
      tcc = tarif_class_categories[tarif_classes_category_id] 
      where << "( #{tarif_classes_categories_where_hash[tcc['id']]} )" if tcc 
    end
    where.join(' or '.freeze)
  end
  
  def tarif_classes_category_where_hash(tarif_classes_category_id)
    tcc = tarif_class_categories[tarif_classes_category_id]
    tcc ? tarif_classes_categories_where_hash[tcc['id'.freeze]] : nil
  end
  
  def calculate_tarif_classes_categories_where_hash
    @tarif_classes_categories_where_hash = {}
    tarif_class_categories.each {|key, value| tarif_classes_categories_where_hash[value[:id]] = initial_tarif_classes_category_where_hash(value)}
  end
  
  def initial_tarif_classes_category_where_hash(tarif_classes_category)
    t = tarif_classes_category
    [t['service_category_rouming_id'.freeze], t['service_category_geo_id'.freeze], t['service_category_partner_type_id'.freeze], 
    t['service_category_calls_id'.freeze], t['service_category_one_time_id'.freeze], t['service_category_periodic_id'.freeze]].
      collect { |category_id| category_id ? categories_where_hash[category_id] : true }.compact.join(' and ')
  end
  
  def joined_service_categories_where_hash(category_ids)
    where = ["true"]
    category_ids.each do |category_id|
      cat = categories_where_hash[category_id] 
      where << "( #{cat} )" if cat 
    end
    where.join(' and '.freeze)
  end
  
  def calculate_service_categories_where_hash
    @categories_where_hash = []

    Service::Category.where(:id => category_ids).order(:level).where(:parent_id => nil).each do |c|      
      (childs_category[c['id'.freeze]] << c['id'.freeze]).each do |cat_id|
        categories_where_hash[cat_id] = correct_category_criteria(cat_id).compact.join(' and '.freeze)
        categories_where_hash[cat_id] = 'true' if categories_where_hash[cat_id].blank?
      end   
    end
  end
  
  def correct_category_criteria(category_id)
    (parents_category_criteria(category_id) || [] ) +
    (category_criteria_stand_alone(category_id) || [] ) #+
#    (childs_category_criteria(category_id) || [])
  end

  def parents_category_criteria(category_id)
    categories[category_id].path.collect {|cat_id| category_criteria_stand_alone(cat_id) } if categories[category_id] and categories[category_id]['path']
  end

  def category_criteria_stand_alone(category_id)      
    criteria_category[category_id].collect {|crit_id| criteria_where_hash[crit_id]} if criteria_category[category_id]
  end

  def childs_category_criteria(category_id)
    childs_category[category_id].collect {|cat_id| category_criteria_stand_alone(cat_id) } if childs_category[category_id]
  end

  def calculate_childs_category
    categories.each { |c| add_child_category(c['id'.freeze], c['parent_id'.freeze]) if c and c['parent_id'.freeze] }
  end
  
  def add_child_category(child_id, parent_id)
    childs_category[parent_id] = [] if childs_category[parent_id].blank?
    childs_category[parent_id] << child_id
    add_child_category(child_id, categories[parent_id]['parent_id'.freeze]) if categories[parent_id] and categories[parent_id]['parent_id'.freeze]
#    raise(StandardError, categories[parent_id])
  end
  
  def calculate_service_criteria_where_hash
    @criteria_where_hash = []
    crit = criterium_ids ? Service::Criterium.where(:id => criterium_ids) : Service::Criterium.all    
    crit.each_with_index { |c, index| 
      #raise(StandardError, c.attributes) if index == 132
      criteria_where_hash[c.id] = criterium_where_hash(c)
      }
  end
  
  def criterium_where_hash(criterium)
    criteria_param = parameter_class_sql_name(parameters[criterium['criteria_param_id'.freeze]], context)
    comparison_operator = comparison_operators[criterium['comparison_operator_id'.freeze]]
        
    if criterium.value_choose_option_id == 153#_value_param_is_criterium_param
      value_param_string = parameter_class_sql_name(parameters[criterium['value_param_id'.freeze]], context)
    else
      value_param = criterium['value'.freeze]
      value_param = parameter_class_instance_value(parameters[criterium['value_param_id'.freeze]], context, criterium['value'.freeze]) if criterium['value_param_id'.freeze]
      #raise(StandardError, [criterium.attributes, value_param]) if criterium.id == 1870
      begin      
        value_param = eval(criterium['eval_string'.freeze]) if criterium['eval_string'.freeze]
      rescue
        raise(StandardError, [criterium, criterium['eval_string'.freeze]])
      end
      value_param_string = "'#{value_param}'".freeze
    end
    
    result = case comparison_operator
    when 'in'
      "(#{criteria_param} = any('{#{value_param.join(', ')}}') )".freeze
    when 'not_in'
      "(#{criteria_param} != all('{#{value_param.join(', ')}}') )".freeze
    else
      "(#{criteria_param} #{comparison_operator} #{value_param_string})".freeze
    end 
    
#    raise(StandardError, result) if criterium.id == 1870 #Customer::Call.where(result).size < 0
    
    result     
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
#      raise(StandardError, c.attributes) if !c.service_category_id
      criteria_category[c.service_category_id] = [] if criteria_category[c.service_category_id].blank?
      criteria_category[c.service_category_id] << c.id
    end
  end
  
  def load_service_categories
    @categories = []; @childs_category = []; @categories_as_hash = {}
    Service::Category.where(:id => category_ids).order(:level).each do |c|
      categories_as_hash[c.id] = c 
      categories[c.id] = c 
    end  
    calculate_childs_category      
  end
  
  def load_category_groups
    @category_groups = {}
    category_group_ids = Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.where.not(:as_standard_category_group_id => nil).
    pluck(:as_standard_category_group_id).uniq
    
    Service::CategoryGroup.where(:id => category_group_ids).each do |st|
      category_groups[st.id] = st
    end
  end
  
  def load_service_category_group_ids_by_tarif_class
    @service_category_group_ids_by_tarif_class = {}
    category_group_ids = Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.where.not(:as_standard_category_group_id => nil).
      group("tarif_class_id").pluck("tarif_class_id, array_agg(as_standard_category_group_id)").
      each {|ctc| service_category_group_ids_by_tarif_class[ctc[0]] =  ctc[1]}        
  end
  
  def load_required_service_category_tarif_class_ids
    @tarif_class_categories = {}
    Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.#original.uniq
      each do |ctc| 
        tarif_class_categories[ctc.id] = ctc 
        raise(StandardError, []) if !ctc
      end        
  end
  
  def load_service_category_tarif_class_ids_by_tarif_class
    @tarif_class_categories_by_tarif_class = {}; @tarif_class_categories_by_category_group = {}
    Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.where.not(:as_standard_category_group_id => nil).#original.
      group("as_standard_category_group_id").pluck("as_standard_category_group_id, array_agg(id)").
      each {|ctc| tarif_class_categories_by_category_group[ctc[0]] =  ctc[1]}        

    Service::CategoryTarifClass.where(:tarif_class_id => tarif_class_ids).active.#where(:as_standard_category_group_id => nil).#original.
      group("tarif_class_id").pluck("tarif_class_id, array_agg(id)").
      each {|ctc| tarif_class_categories_by_tarif_class[ctc[0]] =  ctc[1]}        
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
  
