# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "dotenv-rails"
gem "rails", "~> 5.0.0"
gem "mysql2"
gem "puma"
gem "uglifier", ">= 1.3.0"
gem "jquery-rails"
gem "jpmobile", "~> 5.0.0"
gem "config"
gem "twitter"
gem "omniauth"
gem "omniauth-twitter"
gem "twitter-text"
gem "turnout"
gem "slim-rails"
gem "therubyracer", platforms: :ruby
gem "sidekiq"
gem "sidekiq-cron", "~> 1.1"
gem "redis-namespace"
gem "bootsnap", ">= 1.1.0", require: false
gem "activerecord-import"
gem "devise"
gem "sentry-raven"

group :development do
  gem "web-console", "~> 2.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rails-erd"
  gem "capistrano", "~> 3.11", require: false
  gem "capistrano-rbenv", require: false
  gem "capistrano-bundler", require: false
  gem "capistrano-rails", require: false
  gem "capistrano3-puma", require: false
  gem "capistrano-sidekiq", require: false
end
group :development, :test do
  gem "rspec-rails", "~> 3.5"
  gem "factory_bot_rails"
  gem "database_cleaner"
  gem "rspec_junit_formatter"
  gem "rubocop", require: false
  gem "rubocop-rails_config", require: false
end
