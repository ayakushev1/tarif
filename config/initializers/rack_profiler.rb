if ['development', 'production'].include?(Rails.env)
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rails.application.middleware.delete(Rack::MiniProfiler)
  Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
  
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfiler.config.start_hidden = false
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
  
end

