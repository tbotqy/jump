# frozen_string_literal: true

class DestroyUserJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    user         = User.find(user_id)
    status_count = user.statuses.count
    user.destroy!
    StatusCount.decrement_by(status_count)
  end
end
