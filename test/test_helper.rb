ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
#require "minitest/rails"

#require 'minitest/rails/capybara'
#require 'minitest/focus'
#require 'minitest/colorize'

# Uncomment for awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
    fixtures :all

    def self.prepare
      # Add code that needs to be executed before test suite start
    end
    prepare

    def setup
      # Add code that need to be executed before each test
    end

    def teardown
      # Add code that need to be executed after each test
    end
end