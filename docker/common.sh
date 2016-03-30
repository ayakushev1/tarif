#!/bin/bash

export RAILS_ENV=production
export RACK_ENV=production
export DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@172.17.0.1/mytariffs"
