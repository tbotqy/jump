class SlowQueryLogger
  MAX_DURATION = 1.0

  def self.initialize!
    ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, id, payload|
      duration = finish.to_f - start.to_f

      if duration >= MAX_DURATION
        message = "env: `#{Rails.env}`, duration: `#{duration.floor(2)} sec`\n```#{payload[:sql]}```"
        NotifySlowQueryToSlackJob.perform_later(message: message)
      end
    end
  end
end

SlowQueryLogger.initialize!
