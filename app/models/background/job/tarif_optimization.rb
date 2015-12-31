module Background::Job
  class TarifOptimization < Background::Job::Base
    
    def initialize(*)
      super
      self.worker_type = 'tarif_optimization'
    end
    
    def perform
      ::TarifOptimization::TarifOptimizatorRunner.calculate(options)
=begin
      tarif_optimizator = ::TarifOptimization::TarifOptimizator.new(options)

      ::Customer::Stat::PerformanceChecker.apply(::TarifOptimization::TarifOptimizator)
      ::Customer::Stat::PerformanceChecker.apply(::TarifOptimization::FinalTarifSetGenerator)
      ::Customer::Stat::PerformanceChecker.apply(::TarifOptimization::CurrentTarifSet)
      ::Customer::Stat::PerformanceChecker.apply(::TarifOptimization::QueryConstructor)
      ::Customer::Stat::PerformanceChecker.apply(::TarifOptimization::CurrentTarifOptimizationResults)
      ::Customer::Stat::PerformanceChecker.apply(::TarifOptimization::CurrentTarifOptimizationResults)

      tarif_optimizator.calculate_all_operator_tarifs
      tarif_optimizator.update_minor_results
      
      UserMailer.tarif_optimization_complete(options[:user_input][:user_id]).deliver if options[:is_send_email] == true
=end
    end    

    def queue_name
      worker_type
    end

    def max_attempts
      1
    end
    
    def destroy_failed_jobs
      false
    end

  end
end