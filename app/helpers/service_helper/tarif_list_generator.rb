class ServiceHelper::TarifListGenerator
  attr_reader :operators, :all_services, :tarifs, :tarif_sets, :common_services, :tarif_options, :all_tarif_options, 
              :max_tarif_slice, :tarif_slices
  def initialize
    @operators = [1025, 1028, 1030]
    @tarifs = [[0], [100], [200]]#tarifs are groupped by operator
    @tarif_sets = [[[0, 93, 77]], [[100, 175, 176, 177]], [[200, 275, 276, 277]]] #tarif_sets are groupped by operator and tarif
    @common_services = [[[93, 77]], [[175, 176, 177]], [[275, 276, 277]]] #common_services are groupped by operator
    @tarif_options = [[[[81]]], [[[nil]]], [[[nil]]]]#tarif_options are groupped by operator and tarif
    @tarif_options = [[[[nil, 80, 81]]], [[[nil]]], [[[nil]]]]#tarif_options are groupped by operator and tarif
#    @tarif_options = [[[[nil, 80, 81], [nil, 82, 83, 84, 85, 86]]], [[[nil]]], [[[nil]]]]#tarif_options are groupped by operator and tarif
    @all_services = calculate_all_services
    @all_tarif_options = calculate_all_tarif_options
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
        tarif_slices[i][slice] = {:ids => [], :prev_ids => []}
        j = 0
        tarif_sets[i].each_index do |tarif_set_index|
          tarif_option_combinations(tarif_options[i][tarif_set_index]).each do |tarif_option_combination|
            if slice == 0
              tarif_slices[i][slice][:ids] << tarif_sets[i][tarif_set_index].reverse[slice]
              tarif_slices[i][slice][:prev_ids] << tarif_option_combination
            else 
              tarif_slices[i][slice][:ids] << tarif_sets[i][tarif_set_index].reverse[slice]
              prev = tarif_slices[i][slice - 1][:prev_ids][j] if tarif_slices[i][slice - 1][:prev_ids]
              prev = ( [tarif_slices[i][slice - 1][:ids][j] ] + prev ) if tarif_slices[i][slice - 1][:ids]
              tarif_slices[i][slice][:prev_ids][j] = prev
            end
            j += 1
          end
        end
      end
    end
  end
  
  def calculate_max_tarif_slice
    @max_tarif_slice = [3, 4, 4]
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
    tarif_ids.collect {|tarif_id| tarif_id.to_s if tarif_id}.compact.join('_')
  end

end
