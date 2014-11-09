module Background::Job
  Base = Struct.new(:options, :is_send_email, :worker_type, :number, :min_number) do
    
    def initialize(*)
      super
      self.worker_type = 'default_worker_type'
      self.number = 1
      self.min_number = 0
    end
    
    def perform
      raise(StandardError, "Background::Job::Base should be used for starting jobs")
    end
    
    def enqueue(job)
      worker_manager.start_worker_if_no_worker_is_running(worker_type, number)
    end
    
    def success(job)
      worker_manager.stop_workers_if_no_new_or_running_jobs(worker_type, min_number)
    end
    
    def worker_manager
      Background::WorkerManager::Manager
    end
    
  end
end