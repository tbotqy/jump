class User < ApplicationRecord
  devise :omniauthable

  has_many :statuses, dependent: :destroy
  has_many :following_twitter_ids, dependent: :delete_all
  has_many :tweet_import_job_progresses, dependent: :delete_all

  # FIXME : this is referenced only at one point
  # consider to delete this scope and replace with some private method
  scope :active, -> {where(deleted: false)}

  class << self
    def register_or_update!(auth)
      user = find_or_initialize_by(twitter_id: auth.uid, deleted: false)
      user.assign(auth)
      user.save!
    end

    def find_active_with_auth(auth)
      find_by(twitter_id: auth.uid, deleted: false)
    end

    def deactivate_account(user_id)
      # just turn the flag off, not actually delete user's status from database
      deleted_status_count = Status.where(user_id: user_id).update_all(deleted: true)
      # update stats
      ActiveStatusCount.decrement_by(deleted_status_count)
      # turn the flag off for users table
      find(user_id).update_attribute(:deleted, true)
    end
  end

  def status_newest_in_tweeted_time
    statuses.newest_in_tweeted_time
  end

  def last_status
    statuses&.last
  end

  def has_any_status?
    statuses.exists?
  end

  def finish_initial_import!
    self.finished_initial_import = true
    save!
  end

  def has_working_job?
    tweet_import_job_progresses.unfinished.exists?
  end

  def friend_user_ids
    self.class.where(twitter_id: following_twitter_ids.pluck(:following_twitter_id)).pluck(:id)
  end

  def friend_count
    following_twitter_ids.count
  end

  def assign(auth)
    info = auth.extra.raw_info
    self.assign_attributes(
      twitter_id: info.id,
      name: info.name,
      screen_name: info.screen_name,
      protected: info.protected?,
      profile_image_url_https: info.profile_image_url_https,
      time_zone: info.time_zone,
      utc_offset: info.utc_offset,
      twitter_created_at: Time.zone.parse(info.created_at).to_i,
      lang: info.lang,
      token: auth.credentials.token,
      token_secret: auth.credentials.secret,
    )
  end
end
