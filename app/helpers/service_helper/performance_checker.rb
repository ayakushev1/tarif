class ServiceHelper::PerformanceChecker
  attr_reader :name, :output_model, :start
  attr_accessor :results
  def initialize(name = nil)
    @name = name || 'performance_checker'
    @output_model = Customer::Stat.where("(result->'#{@name}') is not null")
    @start = current
    @results = {}
  end
  
  def current
    Time.new
  end
  
  def clean_history
    output_model.delete_all
  end
  
  def add_check_point(check_point_name, level = 1)
    measure_time = current
    last_result = results[check_point_name] if results 
    if last_result
      output = {check_point_name => last_result.merge({'time' => measure_time.to_f}) }
    else
      output = {check_point_name => {'time' => measure_time.to_f, 'duration' => 0.0, 'accumulated_duration' => 0.0, 'max_duration' => 0.0, 'count' => 0, 'level' => level} }
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
      level = last_result['level'].to_i
    else
      raise(StandardError, "check_point #{check_point_name} has not been added")
    end
    output = {check_point_name => {
      'time' => measure_time.to_f, 'duration' => duration, 'accumulated_duration' => accumulated_duration, 'max_duration' => max_duration, 'count' => count, 'level' => level} }    
    save_results(output)
#    save(output)
  end
  
  def save_results(output)
    @results ||= {}
    @results = @results.merge(output)
  end
  
  def save(output)
    last_results = results
    if output_model.exists?
      merged_output = last_results ? last_results.merge(output) : output
      output_model.first.update_attributes!({:result => {name => merged_output } } )    
    else
      output_model.create({:result => {name => output} } )    
    end    
  end
  
#  def results
#    result = output_model.select("result->'#{name}' as #{name}").first
#    result.attributes[name] if result
#  end
  
  def show_stat
    result_string = ["\n", "level duration accumulated_duration max_duration count check_point"]
    last_results = results
    last_results.keys.sort_by{|check_point| last_results[check_point]['level'].to_i}.each do |check_point|
#    raise(StandardError, [result, ("%10.0f" % result['level']), 'ssss'])
      s = []
      s << ("%5.0f" % last_results[check_point]['level'])
      s << ("%7.1f" % last_results[check_point]['duration'])
      s << ("%18.1f" % last_results[check_point]['accumulated_duration'])
      s << ("%13.1f" % last_results[check_point]['max_duration'])
      s << ("%5.0f" % last_results[check_point]['count'])
      s << check_point
      result_string << s.join(" ") 
    end
    result_string << "\n"
    result_string.join("\n\n")
  end
end
