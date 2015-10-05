class Customer::Stat::PerformanceChecker  < Aspector::Base #ServiceHelper::PerformanceChecker  
  include Customer::Stat::PerformanceChecker::Helper
  
  attr_reader :name, :start #, :output_model
  attr_accessor :results
  
  def initialize(name = nil)
    @name = name || 'performance_checker'
#    @output_model = Customer::Stat.where(:result_type => 'performance_checker').where(:result_name => @name)
    @start = current
    @results = {}
  end
  
  def run_check_point(check_point_name, level = 1, &block)
    add_check_point(check_point_name, level)
    result = yield
    measure_check_point(check_point_name)
    result
  end
  
end
