#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
#require 'aspector'

class Customer::Stat::PerformanceCheckerAspector  < Aspector::Base #ServiceHelper::PerformanceChecker  
  
  check_points = [
    {:method => :calculate_all_operator_tarifs, :name => 'calculate_all_operator_tarifs', :level => 1, :has_arg => true}
  ]

  check_points.each do  |check_point|
    if check_point[:has_arg]
      around check_point[:method] do |proxy, arg, &block|
        @performance_checker.add_check_point(check_point[:name], check_point[:level])
        proxy.call arg, &block
        @performance_checker.measure_check_point(check_point[:name])
      end
    else
      around check_point[:method] do |proxy, &block|
        @performance_checker.add_check_point(check_point[:name], check_point[:level])
        proxy.call nil, &block
        @performance_checker.measure_check_point(check_point[:name])
      end
    end
  end
end
