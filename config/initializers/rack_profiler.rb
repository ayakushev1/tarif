if ['development', 'production'].include?(Rails.env)
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  
  if ['production'].include?(Rails.env)
    Rails.application.middleware.delete(Rack::MiniProfiler)
#    Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
#    Rails.application.middleware.insert_after(HerokuDeflater::SkipBinary, Rack::MiniProfiler)
    Rails.application.middleware.insert_after(Rack::Cache, Rack::MiniProfiler)
  end 
  
  Rack::MiniProfiler.config.position = 'left'
  Rack::MiniProfiler.config.start_hidden = false
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
  Rack::MiniProfiler.config.disable_caching = false
  
end

