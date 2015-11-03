if ['development', 'production'].include?(Rails.env)
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  
  if ['development', 'production'].include?(Rails.env)
    Rails.application.middleware.delete(Rack::MiniProfiler)
    Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
  end
  
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfiler.config.start_hidden = true
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
  Rack::MiniProfiler.config.disable_caching = false
  
end

