# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV.fetch('JUMP_CACHE_HOST')}:#{ENV.fetch('JUMP_CACHE_PORT')}", namespace: Settings.sidekiq.namespace }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV.fetch('JUMP_CACHE_HOST')}:#{ENV.fetch('JUMP_CACHE_PORT')}", namespace: Settings.sidekiq.namespace }
end

# schedule_file = "config/sidekiq_cron_schedule.yml"
# if File.exist?(schedule_file) && Sidekiq.server?
#  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
# end
