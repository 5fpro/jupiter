source 'https://rubygems.org'
gem 'rails', '~> 5.2'

gem 'dotenv-rails', require: 'dotenv/rails-now'

# DB
gem 'activerecord-postgis-adapter'
gem 'pg', '~> 1.0'
gem 'redis', '~> 3.3'
gem 'redis-objects', require: 'redis/objects'

gem 'aasm'

# stores
gem 'connection_pool'
gem 'dalli'

# ENV
gem 'settingslogic'

# view rendering
gem 'jbuilder', '~> 2.0'
gem 'nested_form'
gem 'rails_autolink'
gem 'simple_form'
gem 'slim'

# assets
gem 'asset_sync'
gem 'coffee-rails'
gem 'sassc-rails'
gem 'uglifier'

# JS plugin
gem 'jquery-rails'
gem 'select2-rails', '~> 3'

# background jobs
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'sinatra', '~> 2.2.3'

# file upload
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

# soft delete
gem 'paranoia'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
group :staging, :production do
  # gem 'newrelic_rpm'
end

group :development do
  # capistrano
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
  # unicorn
  gem 'capistrano3-unicorn'
  # slack
  gem 'slackistrano'

  gem 'annotate'
  # gem 'awesome_print'
  # gem 'better_errors'
  # gem 'binding_of_caller'
  # gem 'guard'
  # gem 'guard-annotate'
  gem 'http_logger'
  # gem 'pry'
  # gem 'pry-rails'
  # gem 'pry-remote'
  # gem 'spring'
  # gem 'web-console', '~> 3.0'
  # gem 'xray-rails'
  gem 'listen'
  gem 'rails_real_favicon'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development, :test do
  gem 'byebug'
  # gem 'factory_girl_rails'
  gem 'factory_bot_rails'
  gem 'rspec'
  gem 'rspec-rails'
end

group :test do
  gem 'timecop'
  gem 'webmock'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

gem 'kaminari'
gem 'rollbar'

# devise
gem 'devise'
gem 'devise-async'

# aws
gem 'aws-sdk-rails'

# unicorn
gem 'unicorn'

# versioning
gem 'paper_trail'

gem 'acts-as-taggable-on'
gem 'slack-notifier'

# model sorting
gem 'acts_as_list'

# front-end
gem 'bootstrap-sass'
gem 'jquery-ui-rails'
gem 'sass-rails'

# SEO
gem 'crummy'
gem 'meta-tags', require: 'meta_tags'
gem 'sitemap_generator'

# model
gem 'ransack'

# omniauth
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-oauth2'
gem 'omniauth-rails_csrf_protection'
# third-party api
gem 'octokit'

gem 'lograge'
