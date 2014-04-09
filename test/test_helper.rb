ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Dir[Rails.root.join("test/helpers/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("lib/pages/**/*.rb")].each { |f| require f }
Rails.application.routes.eval_block( Proc.new { resources :tests } )  

class ActiveSupport::TestCase
  fixtures :all
  
  def self.prepare

  end
  prepare
  
  def setup
  end

  def teardown
  end
  
end
