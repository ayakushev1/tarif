module Background::Job
  class TarifOptimization < Background::Job::Base
    
    def initialize(*)
      super
      self.worker_type = 'tarif_optimization'
    end
    
    def perform
#      raise(StandardError, priority)
      ServiceHelper::TarifOptimizator.new(options).calculate_all_operator_tarifs(false)
      UserMailer.tarif_optimization_complete(options[:user_id]).deliver if is_send_email == true
    end    

    def queue_name
      worker_type
    end

    def max_attempts
      3
    end
    
    def destroy_failed_jobs
      false
    end

  end
end