module Background::WorkerManager
  class Heroku
    include Background::WorkerManager::CommandGenerator
    
    def start_number_of_worker(worker_type, number)    
      run_worker(worker_type, number)
    end
    
    def start_worker_if_no_worker_is_running(worker_type, number)    
#      run_worker(worker_type, number) if (worker_quantity(worker_type) + box.processes.filter(:cmdline => /start --pool=#{worker_type}/).size) < 1
    end
    
    def stop_workers(worker_type, min_number)
      scale_down(worker_type, min_number) if worker_quantity(worker_type) > min_number
    end
    
#    private
    
    def worker_quantity(worker_type)
      info = heroku.formation.info('yakushev-tarif', worker_type.to_s)
      info ? info["quantity"] : 0
    end
    
    def run_worker(worker_type, number)
      Rails.logger.info heroku.formation.batch_update('yakushev-tarif', {"updates" => [
        {"process" => worker_type.to_s, "quantity" => number}]
      })
    end
    
    def scale_down(worker_type, min_number)
      Rails.logger.info heroku.formation.batch_update('yakushev-tarif', {"updates" => [
        {"process" => worker_type.to_s, "quantity" => min_number}]
      })
    end
    
    def heroku
      @heroku ||= PlatformAPI.connect_oauth('06a749ab-32f3-4aab-acbc-8234e33b1d1c')
    end
    
  end
end