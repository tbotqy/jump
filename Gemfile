# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "3.0.0"

gem "dotenv-rails"
gem "rails", "~> 6.1.1"
gem "mysql2"
gem "puma", "~> 5.2"
gem "config"
gem "twitter"
gem "omniauth"
gem "omniauth-twitter"
gem "sidekiq"
gem "sidekiq-cron", "~> 1.1"
gem "redis-namespace", github: "resque/redis-namespace"
gem "redis-objects"
gem "bootsnap", ">= 1.1.0", require: false
gem "devise"
gem "sentry-raven"
gem "kaminari"
gem "ruby-progressbar"
gem "draper"
gem "rack-cors"
gem "slack-notifier", github: "tbotaq/slack-notifier", branch: "ruby3-compatibility"
gem "sitemap_generator"

group :test do
  gem "codecov", require: false
  gem "shoulda-matchers"
end

group :development, :test do
  gem "rspec-rails", "~> 4.0"
  gem "listen"
  gem "factory_bot_rails"
  gem "database_cleaner-active_record"
  gem "database_cleaner-redis"
  gem "rspec_junit_formatter"
  gem "rubocop", require: false
  gem "rubocop-rails_config", require: false
  gem "rubocop-rspec"
  gem "bullet"
end
