ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#Dir[Rails.root.join("test/helpers/**/*.rb")].each { |f| require f }
#Dir[Rails.root.join("lib/pages/**/*.rb")].each { |f| require f }
#Rails.application.routes.eval_block( Proc.new { resources :tests } )  
#Dir[Rails.root.join("lib/calls/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("db/seeds/definitions/*.rb")].sort.each { |f| require f }

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  File.open(".env", "r").each_line do |line|
    begin
      a = line.chomp("\n").split('=',2)
      next if a.blank?
      a[1].gsub!(/^"|"$/, '') if ['\'','"'].include?(a[1][0])
      string_to_eval = "ENV['#{a[0]}']='#{a[1] || ''}'"
      eval string_to_eval
    rescue
      raise(StandardError, [a, string_to_eval])
    end
  end
#  include Devise::TestHelpers
#  include Warden::Test::Helpers
#  Warden.test_mode!
#  fixtures :all
  
  def self.prepare
    @@check_if_test_db_loaded = (User.count == 1) ? false : true
  end
  prepare
  
  def setup
    @@check_if_test_db_loaded.must_be :==, true, 'check if test db loaded!'
  end

  def teardown
    
  end
  
end

