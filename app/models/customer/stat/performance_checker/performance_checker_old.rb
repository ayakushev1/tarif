class Customer::Stat::PerformanceCheckerOld #ServiceHelper::PerformanceChecker
  attr_reader :name, :output_model, :start
  attr_accessor :results
  def initialize(name = nil)
    @name = name || 'performance_checker'
    @output_model = Customer::Stat.where(:result_type => 'performance_checker').where(:result_name => @name)
    @start = current
    @results = {}
  end
  
  def current
    Time.new
  end
  
  def clean_history
    output_model.delete_all
  end
  
  def run_check_point(check_point_name, level = 1, &block)
    add_check_point(check_point_name, level)
    result = yield
    measure_check_point(check_point_name)
    result
  end
  
  def add_check_point(check_point_name, level = 1)
    measure_time = current
    last_result = results[check_point_name] if results 
    if last_result
      output = {check_point_name => last_result.merge({'time' => measure_time.to_f}) }
    else
      output = {check_point_name => 
        {'time' => measure_time.to_f, 'duration' => 0.0, 'accumulated_duration' => 0.0, 'max_duration' => 0.0, 'count' => 0, 'level' => level, 'max_duration_count' => 0} }
    end
    save_results(output)
#    save(output)
  end
  
  def measure_check_point(check_point_name)
    measure_time = current
    last_result = results[check_point_name]# if results 
    if last_result
      duration = (measure_time.to_f - last_result['time'].to_f)#.round(5)
      accumulated_duration = last_result['accumulated_duration'].to_f + duration
      max_duration = [duration, last_result['max_duration'].to_f ].max
      count = last_result['count'].to_i + 1
      max_duration_count = (duration == max_duration ? count : last_result['max_duration_count'].to_i)
      level = last_result['level'].to_i
    else
      raise(StandardError, "check_point #{check_point_name} has not been added")
    end
    output = {check_point_name => {
      'time' => measure_time.to_f, 'duration' => duration, 'accumulated_duration' => accumulated_duration, 
      'max_duration' => max_duration, 'count' => count, 'level' => level, 'max_duration_count' => max_duration_count} }    
    save_results(output)
#    save(output)
  end
  
  def add_current_results_to_saved_results(saved_performance_result, start_time)
    joined_check_point_names = (saved_performance_result || {}).keys + (results || {}).keys - ['total_calculation_time']
    output = {}
    
    output['total_calculation_time'] = {'accumulated_duration' => (current.to_f - start_time.to_f)}
    
    joined_check_point_names.each do |check_point_name|
#      raise(StandardError)
      output[check_point_name] = {}
      if saved_performance_result and saved_performance_result[check_point_name]
        if results and results[check_point_name]
          output[check_point_name]['duration'] = results[check_point_name]['duration']
          output[check_point_name]['accumulated_duration'] = saved_performance_result[check_point_name]['accumulated_duration'].to_f + results[check_point_name]['accumulated_duration'].to_f
          output[check_point_name]['max_duration'] = [saved_performance_result[check_point_name]['max_duration'].to_f + results[check_point_name]['max_duration'].to_f].max
          output[check_point_name]['count'] = saved_performance_result[check_point_name]['count'].to_i + results[check_point_name]['count'].to_i
          output[check_point_name]['max_duration_count'] = [saved_performance_result[check_point_name]['max_duration_count'].to_i + results[check_point_name]['max_duration_count'].to_i].max
          output[check_point_name]['level'] = saved_performance_result[check_point_name]['level']
        else
          output[check_point_name] = saved_performance_result[check_point_name]
        end
      else
        output[check_point_name] = results[check_point_name] if results
      end      
    end
    output
  end
  
  def count(check_point_name)
    results[check_point_name]['count'].to_i
  end
  
  def save_results(output)
    @results ||= {}
    @results = @results.merge(output)
  end
  
  def save(output)
    last_results = results
    if output_model.exists?
      merged_output = last_results ? last_results.merge(output) : output
      output_model.first.update_attributes!({:result => merged_output} )    
    else
      output_model.create({:result_type => 'performance_checker', :result_name => name, :result => output} )    
    end    
  end
  
#  def results
#    result = output_model.select("result->'#{name}' as #{name}").first
#    result.attributes[name] if result
#  end
  
  def show_stat(saved_performance_result = nil)
    result_string = ["\n", "level duration accumulated_duration max_duration average_duration max_duration_count count check_point"]
    last_results = saved_performance_result || results
    last_results.keys.sort_by{|check_point| last_results[check_point]['level'].to_i}.each do |check_point|
#    raise(StandardError, [result, ("%10.0f" % result['level']), 'ssss'])
      s = []
      s << ("%5.0f" % last_results[check_point]['level'])
      s << ("%7.2f" % last_results[check_point]['duration'])
      s << ("%18.2f" % last_results[check_point]['accumulated_duration'])
      s << ("%13.3f" % last_results[check_point]['max_duration'])
      s << ("%15.3f" % (last_results[check_point]['accumulated_duration'].to_f / last_results[check_point]['count'].to_f))
      s << ("%18.0f" % last_results[check_point]['max_duration_count'])
      s << ("%5.0f" % last_results[check_point]['count'])
      s << "       #{check_point}"
      result_string << s.join(" ") 
    end
    result_string << "\n"
    result_string.join("\n\n")
  end

  def show_stat_hash(saved_performance_result = nil)
    result = []
    last_results = saved_performance_result || results
    last_results.keys.sort_by{|check_point| last_results[check_point]['level'].to_i}.each do |check_point|
      s = {
        'level' => last_results[check_point]['level'],
        'duration' => last_results[check_point]['duration'],
        'accumulated_duration' => last_results[check_point]['accumulated_duration'],
        'max_duration' => last_results[check_point]['max_duration'],
        'average_duration' => (last_results[check_point]['accumulated_duration'].to_f / last_results[check_point]['count'].to_f),
        'max_duration_count' => last_results[check_point]['max_duration_count'],
        'count' => last_results[check_point]['count'],
        'check_point' => check_point,
      }
      result << s 
    end
    result
  end
end
