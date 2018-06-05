class ActiveStatusCount
  REDIS_KEY_NAME = "active_status_count_#{Rails.env}"
  private_constant :REDIS_KEY_NAME

  class << self
    def increment
      REDIS.incr(REDIS_KEY_NAME)
    end

    def increment_by(count)
      REDIS.incrby(REDIS_KEY_NAME, count)
    end

    def decrement
      REDIS.decr(REDIS_KEY_NAME)
    end

    def decrement_by(count)
      REDIS.decrby(REDIS_KEY_NAME, count)
    end

    def current_count
      REDIS.get(REDIS_KEY_NAME).to_i
    end

    def count_up
      REDIS.set(REDIS_KEY_NAME, Status.not_deleted.count)
    end
  end
end
