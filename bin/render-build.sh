#!/usr/bin/env bash
# Render build script for Rails
set -e

# Install gems
bundle install --without development test

# Precompile assets
bundle exec rails assets:precompile

# Run database migrations
bundle exec rails db:migrate
