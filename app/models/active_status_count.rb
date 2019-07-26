# frozen_string_literal: true

class ActiveStatusCount
  REDIS_KEY_NAME = "active_status_count"
  private_constant :REDIS_KEY_NAME

  class << self
    def increment_by(count)
      REDIS.incrby(REDIS_KEY_NAME, count)
    end

    def current_count
      REDIS.get(REDIS_KEY_NAME).to_i
    end

    def count_up
      REDIS.set(REDIS_KEY_NAME, Status.count)
    end
  end
end
