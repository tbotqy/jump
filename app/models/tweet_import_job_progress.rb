class TweetImportJobProgress < ActiveRecord::Base
  def increment_count!(by:)
    self.count += by
    save!
  end

  def mark_as_finished!
    self.finished = true
    save!
  end
end
