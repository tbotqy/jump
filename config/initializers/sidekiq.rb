# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis.endpoint, namespace: Settings.sidekiq.namespace }
  config.logger.level = Rails.logger.level
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings.redis.endpoint, namespace: Settings.sidekiq.namespace }
  config.logger.level = Rails.logger.level
end

schedule_file = "config/sidekiq_cron_schedule.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
