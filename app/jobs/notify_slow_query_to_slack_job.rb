# frozen_string_literal: true

class NotifySlowQueryToSlackJob < ApplicationJob
  queue_as :default

  def perform(message:)
    notifier.ping(message)
  end

  private
    def notifier
      Slack::Notifier.new(webhook_url)
    end

    def webhook_url
      ret = ENV.fetch("SLACK_SLOW_QUERY_WEBHOOK_URL")
      if ret.blank?
        raise "A required env var（SLACK_SLOW_QUERY_WEBHOOK_URL）is not supplied."
      end
      ret
    end
end
