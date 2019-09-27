class SlowQueryNotifier
  def self.initialize!
    ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, id, payload|
      duration = finish.to_f - start.to_f

      if duration >= Settings.slow_query_threshold
        message = "env: `#{Rails.env}`, duration: `#{duration.floor(2)} sec`\n```#{payload[:sql]}```"
        NotifySlowQueryToSlackJob.perform_later(message: message)
      end
    end
  end
end

SlowQueryNotifier.initialize!
