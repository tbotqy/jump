# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
# lock "~> 3.13.0"

set :application, "jump"
set :repo_url, "git@github.com:tbotaq/jump.git"
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :rbenv_ruby, "3.0.0"

# used by the generator of .service file for Sidekiq
set :bundler_path, "/home/#{ENV.fetch("DEPLOY_USER")}/.rbenv/shims/bundler"

# Integrate with systemd
set :init_system, :systemd
set :service_unit_name, "sidekiq-#{fetch(:application)}-#{fetch(:stage)}.service"

set :sidekiq_service_name, "sidekiq_#{fetch(:application)}_#{fetch(:sidekiq_env)}"

set :format, :dot if ENV["REDUCE_CAP_LOG"]

set :conditionally_migrate, true

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
append :linked_files, ".env", "frontend/.env" # TODO: add "config/master.key" when upgrade rails

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, ".bundle", "log", "tmp/pids", "tmp/sockets"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
