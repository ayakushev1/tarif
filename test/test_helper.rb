ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#Dir[Rails.root.join("test/helpers/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("lib/pages/**/*.rb")].each { |f| require f }
Rails.application.routes.eval_block( Proc.new { resources :tests } )  
Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

class ActiveSupport::TestCase
  include Devise::TestHelpers
#  fixtures :all
  
  def self.prepare
    @@check_if_tedt_db_loaded = (User.count == 0) ? false : true
  end
  prepare
  
  def setup
    @@check_if_tedt_db_loaded.must_be :==, true, 'check if test db loaded!'
  end

  def teardown
    
  end
  
end
