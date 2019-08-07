class SlowQueryLogger
  MAX_DURATION = 1.0

  def self.initialize!
    ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, id, payload|
      duration = finish.to_f - start.to_f

      if duration >= MAX_DURATION
        message = "slow query detected: #{payload[:sql]}, duration: #{duration}, env: #{Rails.env}"
        NotifySlowQueryToSlackJob.perform_later(message: message)
      end
    end
  end
end

SlowQueryLogger.initialize!
