web: bundle exec puma -C config/puma.rb
worker:  bundle exec rake jobs:work
tarif_optimization:  RAILS_ENV=production bin/delayed_job start --pool=tarif_optimization --exit-on-complete --prefix tarif_optimization