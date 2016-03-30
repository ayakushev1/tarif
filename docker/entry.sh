#!/bin/bash

set -eo pipefail

cd /app

echo "[mytariffs] preparing permissions"
chown -fR app:app /app

echo "[mytariffs] loading config"
source /common.sh

echo "[mytariffs] doing migrations"
sudo -u app -E bash -c "bundle exec rake db:migrate"

echo "[mytariffs] starting Unicorn"
exec sudo -u app -E bash -c "cd /app; exec foreman start"
