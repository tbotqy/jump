REDIS ||= Redis.new(host: ENV.fetch('JUMP_CACHE_HOST'), port: ENV.fetch('JUMP_CACHE_PORT'))
