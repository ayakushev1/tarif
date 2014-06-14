class ServiceHelper::TarifListGenerator
  attr_reader :operators, :all_services, :tarifs, :tarif_sets, :common_services, :tarif_options, :all_tarif_options, 
              :max_tarif_slice, :tarif_slices, :uniq_tarif_option_combinations, :max_tarif_option_combinations, :tarif_options_slices
  def initialize(options = {} )
    @options = options
    @operators = options[:operators] || [1025, 1028, 1030]
    @tarifs = options[:tarifs] || [[], [], [203]]#tarifs are groupped by operator
    @tarifs = options[:tarifs] || [[], [], [201, 202, 203]]#tarifs are groupped by operator

    @tarif_sets = options[:tarif_sets] || [[[]], [[]], [[203]]] #tarif_sets are groupped by operator and tarif
    @tarif_sets = options[:tarif_sets] || [[[]], [[]], [[276, 277, 203]]] #tarif_sets are groupped by operator and tarif
    @tarif_sets = options[:tarif_sets] || [[[]], [[]], [[276, 277, 201], [276, 277, 202], [276, 277, 203]]] #tarif_sets are groupped by operator and tarif

    @common_services = options[:common_services] || [[[]], [[]], [[]]] #common_services are groupped by operator
    @common_services = options[:common_services] || [[[]], [[]], [[276, 277]]] #common_services are groupped by operator

    @tarif_options = options[:tarif_options] || [[[[nil]]], [[[nil]]], [[[nil]]]]#tarif_options are groupped by operator and tarif
    @tarif_options = options[:tarif_options] || [[[[nil]]], [[[nil]]], [[[283]]]]#tarif_options are groupped by operator and tarif
    @tarif_options = options[:tarif_options] || [[[[nil]]], [[[nil]]], [[[nil, 283, 293]]]]#tarif_options are groupped by operator and tarif
    @tarif_options = options[:tarif_options] || [[[[nil]]], [[[nil]]], [[[nil, 283, 293]], [[nil, 283, 293]], [[nil, 283, 293]]]]#tarif_options are groupped by operator and tarif

    @all_services = calculate_all_services
    @all_tarif_options = calculate_all_tarif_options
    calculate_uniq_tarif_option_combinations
    calculate_tarif_options_slices
    calculate_max_tarif_slice
    calculate_tarif_slices
  end
  
  def calculate_all_services
    result = []
    operators.each_index { |i| result << tarif_sets[i].flatten.compact.uniq + tarif_options[i].flatten.compact.uniq }
    result 
  end
  
  def calculate_all_tarif_options
    result = []
    operators.each_index { |i| result << tarif_options[i].flatten.compact.uniq }
    result 
  end
  
  def calculate_tarif_slices
    @tarif_slices = []
    operators.each_index do |i| 
      tarif_slices[i] = []
      max_tarif_slice[i].times do |slice|
        tarif_slices[i][slice] = {:ids => [], :prev_ids => [], :set_ids => [], :prev_set_ids => []}
        j = 0
        tarif_sets[i].each_index do |tarif_set_index|
          tarif_option_combinations(tarif_options[i][tarif_set_index]).each do |tarif_option_combination|
            prev_ids = if slice == 0
              (tarif_option_combination || [])
            else 
              prev = tarif_slices[i][slice - 1][:prev_ids][j]# if tarif_slices[i][slice - 1][:prev_ids]
              ([tarif_slices[i][slice - 1][:ids][j] ] + prev )# if tarif_slices[i][slice - 1][:ids]
            end
            tarif_slices[i][slice][:ids] << tarif_sets[i][tarif_set_index].reverse[slice]
            tarif_slices[i][slice][:prev_ids] << prev_ids
            tarif_slices[i][slice][:prev_set_ids] << tarif_set_id(prev_ids)
            tarif_slices[i][slice][:set_ids] << tarif_set_id([tarif_sets[i][tarif_set_index].reverse[slice]] + prev_ids)

            j += 1
          end
        end
      end
    end
  end
  
  def calculate_max_tarif_slice
    @max_tarif_slice = tarif_sets.collect do |operator_tarif_sets|
      result = 0
      operator_tarif_sets.each {|tarif_set| set_size = tarif_set.count; result = set_size if result < set_size } if operator_tarif_sets
      result
    end
  end
  
  def calculate_uniq_tarif_option_combinations
    @uniq_tarif_option_combinations = []
    @max_tarif_option_combinations = []
    operators.each_index do |i| 
      uniq_tarif_option_combinations[i] = {}
      max_tarif_option_combinations[i] = 0
      tarif_sets[i].each_index do |tarif_set_index|
        tarif_option_combinations(tarif_options[i][tarif_set_index]).each do |tarif_option_combination|
          tarif_option_set_id = tarif_set_id(tarif_option_combination)
          unless tarif_option_set_id.blank? or uniq_tarif_option_combinations[i][tarif_option_set_id]
            uniq_tarif_option_combinations[i][tarif_option_set_id] = tarif_option_combination.compact
            tarif_option_combinations_count = tarif_option_combination.count
            max_tarif_option_combinations[i] = tarif_option_combinations_count if tarif_option_combinations_count > max_tarif_option_combinations[i]
          end
        end
      end
    end
  end
  
  def calculate_tarif_options_slices
    @tarif_options_slices = []
    operators.each_index do |i|
      tarif_options_slices[i] = []
      max_tarif_option_combinations[i].times do |slice|
        tarif_options_slices[i][slice] = {:ids => [], :prev_ids => [], :set_ids => [], :prev_set_ids => []}
        uniq_tarif_option_combinations[i].each do |key, combination|          
          if combination.count == (slice + 1)
            prev_ids = (slice == 0) ? [] : combination[0..(slice - 1)]
            tarif_options_slices[i][slice][:prev_ids] = prev_ids
            tarif_options_slices[i][slice][:ids] << combination[slice]
            tarif_options_slices[i][slice][:prev_set_ids] << tarif_set_id(prev_ids)
            tarif_options_slices[i][slice][:set_ids] << tarif_set_id([combination[slice]] + prev_ids)
          end
        end
      end
    end
  end
  
  def tarif_option_combinations(tarif_option_ids)
    result = tarif_option_ids[0]
    case tarif_option_ids.count
    when 0
      result = []
    when 1
      result = tarif_option_ids[0].collect {|tarif_option| [tarif_option]}
    when 2
      tarif_option_ids.last(tarif_option_ids.count - 1).each { |tarif_option| result = result.product(tarif_option) }
    else 
      tarif_option_ids.last(tarif_option_ids.count - 1).each { |tarif_option| result = result.product(tarif_option) }
      result.each_index { |i| result[i] = result[i].flatten }
    end
    result
  end 
  
  def tarif_set_id(tarif_ids)
    tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
  end

end
