module Background::WorkerManager
  class Local
    include Background::WorkerManager::CommandGenerator
    
    def start_number_of_worker(worker_type, number)    
      run_worker(worker_type, number)
    end
    
    def start_worker_if_no_worker_is_running(worker_type, number)    
      Rails.logger.info "Background::WorkerManager::Local.start_worker_if_no_worker_is_running condition #{((worker_quantity(worker_type) + box.processes.filter(:cmdline => /start --pool=#{worker_type}/).size) < 1)}"
#      run_worker(worker_type, number) if (worker_quantity(worker_type) + box.processes.filter(:cmdline => /start --pool=#{worker_type}/).size) < 1
    end
    
    def stop_workers(worker_type, min_number)
      Rails.logger.info "Background::WorkerManager::Local.stop_workers condition #{(worker_quantity(worker_type) - box.processes.filter(:cmdline => /stop --pool=#{worker_type}/).size) > min_number}"
#      scale_down(worker_type, min_number) if (worker_quantity(worker_type) - box.processes.filter(:cmdline => /stop --pool=#{worker_type}/).size) > min_number
    end
    
    private
    
    def worker_quantity(worker_type)
      box.processes.filter(:cmdline => /#{worker_type}\/delayed_job/).size
    end
    
    def run_worker(worker_type, number)
      Rails.logger.info box[Rails.root].bash "RAILS_ENV=development bin/delayed_job start #{start_command_option_string(worker_type, number)}", :background => true
    end
    
    def scale_down(worker_type, min_number)
      Rails.logger.info box[Rails.root].bash "RAILS_ENV=development bin/delayed_job stop #{stop_command_option_string(worker_type)}", :background => true
    end
    
    def box
      @box ||= Rush::Box.new
    end
    
  end
end