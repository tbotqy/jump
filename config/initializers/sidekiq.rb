Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV.fetch('JUMP_CACHE_HOST')}:#{ENV.fetch('JUMP_CACHE_PORT')}", namespace: "sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV.fetch('JUMP_CACHE_HOST')}:#{ENV.fetch('JUMP_CACHE_PORT')}", namespace: "sidekiq_#{Rails.env}" }
end
