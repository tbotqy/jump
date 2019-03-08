REDIS ||= Redis.new(host: ENV.fetch('CACHE_HOST'), port: ENV.fetch('CACHE_PORT'))
