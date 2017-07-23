class User < ActiveRecord::Base

  has_many :statuses, dependent: :destroy
  has_many :friends, dependent: :delete_all

  scope :active, lambda{where(deleted_flag: false)}

  class << self
    def register_or_update!(auth)
      user = find_or_initialize_by(twitter_id: auth.uid, deleted_flag: false)
      user.assign(auth)
      user.save!
    end

    def find_active_with_auth(auth)
      find_by(twitter_id: auth.uid, deleted_flag: false)
    end

    def deactivate_account(user_id)
      # just turn the flag off, not actually delete user's status from database
      deleted_status_count = Status.where(user_id: user_id).update_all(deleted_flag: true)
      # update stats
      DataSummary.decrease('active_status_count', deleted_status_count)
      # turn the flag off for users table
      find(user_id).update_attribute(:deleted_flag, true)
    end

    def active_twitter_id_exists?(twitter_id)
      # check if user exists by searching given twitter id
      where(twitter_id: twitter_id).where(deleted_flag: false).exists?
    end

    def get_active_users
      where(deleted_flag: false).order('created_at DESC')
    end

    def get_gone_users
      where(deleted_flag: true).order('updated_at DESC')
    end

    # maintenance methods --

    def delete_gone_users
      deleted_user_count = 0
      get_gone_users.each do |gone_user|
        if gone_user.destroy
          deleted_user_count += 1
        end
      end
      deleted_user_count
    end

    def delete_gone_and_duplicated_users
      # delete already-flagged users before process
      delete_gone_users

      # detect the duplicated user account
      duplicated_tids = []
      User.get_active_users.each do |u|
        count = where(twitter_id: u.twitter_id).count
        if count > 1
          duplicated_tids.push(u.twitter_id)
        end
      end

      return 0 if duplicated_tids.size == 0

      # once flag all the duplicated users to deleted
      duplicated_tids.each do |tid|
        where(twitter_id: tid).update_all(deleted_flag: true)
      end
      # delete with group by used
      group(:twitter_id).each do |u|
        u.update_attributes(deleted_flag: false)
      end

      # delete flagged users and return the number of them
      delete_gone_users

    end

  end

  def has_friend?
    Friend.exists?(user_id: self.id)
  end

  def has_imported?
    # check if user has imported own tweets
    self.initialized_flag
  end

  def has_any_status?
    Status.unscoped.where(user_id: self.id).present?
  end

  def get_oldest_active_tweet_id
    Status.where(user_id: self.id).maximum(:status_id_str_reversed)*-1 rescue "false"
  end

  def get_active_status_count
    Status.where(user_id: self.id, deleted_flag: false).count
  end

  def assign(auth)
    info = auth.extra.raw_info
    self.assign_attributes(
      twitter_id: info.id,
      name: info.name,
      screen_name: info.screen_name,
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
