module Background::WorkerManager
  class Heroku
    include Background::WorkerManager::CommandGenerator
    
    def start_number_of_worker(worker_type, number)    
#      Rails.logger.info "Background::WorkerManager::Heroku.start_number_of_worker number #{number}"
      total_number = number + worker_quantity(worker_type) 
      run_worker(worker_type, total_number)
    end
    
    def start_worker_if_no_worker_is_running(worker_type, number)    
#      run_worker(worker_type, number) if (worker_quantity(worker_type) + box.processes.filter(:cmdline => /start --pool=#{worker_type}/).size) < 1
    end
    
    def stop_workers(worker_type, min_number)
#      Rails.logger.info "Background::WorkerManager::Heroku.stop_workers worker_quantity #{worker_quantity(worker_type)}"    
      scale_down(worker_type, min_number) if worker_quantity(worker_type) > min_number
    end
    
#    private
    
    def worker_quantity(worker_type)
      info = heroku.formation.info(ENV["MY_HEROKU_APP_NAME"], worker_type.to_s)
      info ? info["quantity"] : 0
    end
    
    def run_worker(worker_type, number)
      Rails.logger.info heroku.formation.batch_update(ENV["MY_HEROKU_APP_NAME"], {"updates" => [
        {"process" => worker_type.to_s, "quantity" => number}]
      })
    end
    
    def scale_down(worker_type, min_number)
      Rails.logger.info heroku.formation.batch_update(ENV["MY_HEROKU_APP_NAME"], {"updates" => [
        {"process" => worker_type.to_s, "quantity" => min_number}]
      })
    end
    
    def heroku
      @heroku ||= PlatformAPI.connect_oauth(ENV["MY_HEROKU_API_TOKEN"])
    end
    
  end
end