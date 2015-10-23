#namespace :test do
#  namespace :capybara do
#    Rake::TestTask.new do |t|
#      t.name = "test:capybara:page"
#      t.libs = ["test", 'lib/pages']
#      t.test_files = Dir.glob("#{Rails.root}/test/models/site_pages/**/*_test.rb").sort
#      t.warning = false
#      t.verbose = false
#    end
#  end
#end