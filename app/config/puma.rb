threads Integer(ENV['MIN_THREADS']  || 0), Integer(ENV['MAX_THREADS'] || 5) 

workers Integer(ENV['PUMA_WORKERS'] || 1) 

preload_app! 
 
rackup DefaultRackup 
port ENV['PORT'] || 3000 
environment ENV['RACK_ENV'] || 'development' 
   
on_worker_boot do 
  # worker specific setup 
  ActiveSupport.on_load(:active_record) do 
    config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['MAX_THREADS'] || 5
    ActiveRecord::Base.establish_connection(config) 
  end 

  # If you are using Redis but not Resque, change this 
  if defined?(Resque) 
    Resque.redis = ENV["OPENREDIS_URL"] || "redis://127.0.0.1:6379" 
    Rails.logger.info('Connected to Redis') 
  end 
end 
