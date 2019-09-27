# frozen_string_literal: true

REDIS = Redis::Namespace.new(
  Settings.redis.namespace,
  redis: Redis.new(url: Settings.redis.endpoint)
)

Redis.current = REDIS # for redis-objects
