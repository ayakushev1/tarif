module Background::WorkerManager::CommandGenerator
  extend self 
  
  def start_command_option_string(worker_type, number_of_workers = 1)
    options = command_options_by_worker_type(worker_type)
    [
      "--pool=#{options[:queue]}:#{number_of_workers}",
      ("--exit-on-complete" if options[:exit_on_complete]), 
      "--prefix #{options[:prefix]}",
    ].compact.join(' ')
  end
  
  def stop_command_option_string(worker_type, number_of_workers = nil)
    options = command_options_by_worker_type(worker_type)
    [
      "--pool=#{options[:queue]}",
      ("#{number_of_workers}" if number_of_workers)
    ].compact.join(':')
  end
  
  def command_options_by_worker_type(worker_type)
    options = {
      :exit_on_complete => true,
      :prefix => worker_type.to_s,
      :queue => worker_type.to_s,
    }
  end

end

=begin
Usage: script/delayed_job [options] start|stop|restart|run
-h, --help                       Show this message
-e, --environment=NAME           Specifies the environment to run this delayed jobs under (test/development/production).
    --min-priority N             Minimum priority of jobs to run.
    --max-priority N             Maximum priority of jobs to run.
-n, --number_of_workers=workers  Number of unique workers to spawn
    --pid-dir=DIR                Specifies an alternate directory in which to store the process ids.
-i, --identifier=n               A numeric identifier for the worker.
-m, --monitor                    Start monitor process.
    --sleep-delay N              Amount of time to sleep when no jobs are found
    --read-ahead N               Number of jobs from the queue to consider
-p, --prefix NAME                String to be prefixed to worker process names
    --queues=queues              Specify which queue DJ must look up for jobs
    --queue=queue                Specify which queue DJ must look up for jobs
    --exit-on-complete           Exit when no more jobs are available to run
=end