# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.6.3"

gem "dotenv-rails"
gem "rails", "~> 6.0.0"
gem "mysql2"
gem "puma"
gem "config"
gem "twitter"
gem "omniauth"
gem "omniauth-twitter"
gem "twitter-text"
gem "turnout"
gem "sidekiq"
gem "sidekiq-cron", "~> 1.1"
gem "redis-namespace"
gem "redis-objects"
gem "bootsnap", ">= 1.1.0", require: false
gem "activerecord-import"
gem "devise"
gem "sentry-raven"
gem "kaminari"
gem "ruby-progressbar"
gem "draper"
gem "rack-cors"
gem "slack-notifier"

group :development do
  gem "rails-erd"
end

group :test do
  gem "codecov", require: false
  gem "shoulda-matchers"
end

group :development, :test do
  gem "rspec-rails", "~> 3.5"
  gem "listen"
  gem "factory_bot_rails"
  gem "database_cleaner"
  gem "rspec_junit_formatter"
  gem "rubocop", require: false
  gem "rubocop-rails_config", require: false
  gem "rubocop-rspec"
  gem "bullet"
end
