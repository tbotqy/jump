# frozen_string_literal: true

REDIS = Redis::Namespace.new(
  Settings.redis.namespace,
  redis: Redis.new(
    host: ENV.fetch("JUMP_CACHE_HOST"), port: ENV.fetch("JUMP_CACHE_PORT")
  )
)
