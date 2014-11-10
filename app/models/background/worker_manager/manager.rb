module Background::WorkerManager
  class Manager
    
    def self.start_number_of_worker(worker_type, number = 1)
      worker_manager.start_number_of_worker(worker_type, number)
    end
    
    def self.start_worker_if_no_worker_is_running(worker_type, number = 1)      
      worker_manager.start_worker_if_no_worker_is_running(worker_type, number)
    end
    
    def self.stop_workers_if_no_new_or_running_jobs(worker_type, min_number = 0)  
      Rails.logger.info "Background::WorkerManager::Manager.stop_workers_if_no_new_or_running_jobs condition #{are_there_any_new_or_running_job?(worker_type)}"    
      Rails.logger.info "Delayed::Job.where(:queue => worker_type.to_s, :failed_at => nil).count #{Delayed::Job.where(:queue => worker_type.to_s, :failed_at => nil).count}"    
      worker_manager.stop_workers(worker_type, min_number) unless are_there_any_new_or_running_job?(worker_type)
    end

    def self.worker_quantity(worker_type)
      worker_manager.send(:worker_quantity, worker_type)
    end

    def self.worker_manager
      @worker_manager ||= if Rails.env.production?
        Background::WorkerManager::Heroku.new()
      else
        Background::WorkerManager::Local.new()
      end
    end

    def self.are_there_any_new_or_running_job?(worker_type)
      Delayed::Job.where(:queue => worker_type.to_s, :failed_at => nil).exists?
    end
    
  end
end