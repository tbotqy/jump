class TweetImportJobProgress < ActiveRecord::Base
  belongs_to :user

  scope :finished, -> {where(finished: true)}
  scope :unfinished, -> {where(finished: false)}

  class << self
    def latest_by_user_id(user_id)
      where(user_id: user_id).last
    end
  end

  def increment_count!(by:)
    self.count += by
    save!
  end

  def mark_as_finished!
    self.finished = true
    save!
  end
end
