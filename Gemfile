source 'http://rubygems.org'
ruby "2.1.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#TODO обновить до 4.1.0
gem 'rails', '4.1.0'

gem 'pg'
gem 'nokogiri'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.1'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'bootstrap-sass', '~> 2.3'
  gem 'uglifier', '>= 1.3.0'
end

gem 'formtastic'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'bootstrap-datepicker-rails'
gem 'bootswatch-rails'

gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'jquery-turbolinks'

gem 'remotipart', '~> 1.2' #for ajax file upload
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby' , '~> 3.1.2'

#gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
#gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'

# Use unicorn as the app server
# gem 'unicorn'

#group :test, :development do
#  gem "thin"
#end

# Deploy with Capistrano
# gem 'capistrano', group: :development

# To use debugger
group :development do
  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
  gem 'localtunnel'
  gem 'spring'
end

group :test do
  gem 'minitest-spec-rails'
  gem 'database_cleaner'
#  gem 'connection_pool'
#  gem 'minitest-rails-capybara'
  gem 'capybara_minitest_spec'
  gem "capybara-webkit"  
  gem 'selenium-webdriver'
#  gem 'minitest-colorize'
#  gem 'minitest-focus'
end

group :production do
  gem 'rails_12factor'
end

#gem 'spawnling', '~>2.1' #background processing
gem 'spawnling', :git => 'git://github.com/tra/spawnling'

gem 'puma'



# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

