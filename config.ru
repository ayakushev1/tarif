# This file is used by Rack-based servers to start the application.
#if Rails.env.development?
#  RubyProf.measure_mode = RubyProf::MEMORY
#  use Rack::RubyProf, :path => Rails.root.join("tmp/rubyprof")
#end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

