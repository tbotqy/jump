# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i|twitter|

  has_many :statuses, dependent: :destroy
  has_many :followees, dependent: :delete_all
  has_many :tweet_import_job_progresses, dependent: :delete_all

  validates :uid,                     uniqueness: true, presence: true, length: { maximum: 255 }
  validates :twitter_id,              numericality: true, length: { maximum: 20 }
  validates :provider,                presence: true, length: { maximum: 255 }
  validates :name,                    presence: true, length: { maximum: 255 }
  validates :screen_name,             presence: true, length: { maximum: 255 }
  validates :protected_flag,          inclusion: { in: [true, false] }
  validates :profile_image_url_https, length: { maximum: 255 }
  validates :twitter_created_at,      numericality: true, length: { maximum: 11 }
  validates :access_token,            presence: true, length: { maximum: 255 }
  validates :access_token_secret,     presence: true, length: { maximum: 255 }
  validates :token_updated_at,        numericality: true, length: { maximum: 11 }, allow_nil: true
  validates :statuses_updated_at,     numericality: true, length: { maximum: 11 }, allow_nil: true
  validates :closed_only,             inclusion: { in: [true, false] }, allow_nil: true

  class << self
    def register_or_update!(provider:, uid:, twitter_id:, twitter_created_at:, name:, screen_name:, protected_flag:, profile_image_url_https:, access_token:, access_token_secret:)
      user = find_or_initialize_by(uid: uid)
      user.update!(
        twitter_id:              twitter_id,
        provider:                provider,
        name:                    name,
        screen_name:             screen_name,
        protected_flag:          protected_flag,
        profile_image_url_https: profile_image_url_https,
        twitter_created_at:      Time.zone.parse(twitter_created_at).to_i,
        access_token:            access_token,
        access_token_secret:     access_token_secret
      )
      user
    end
  end

  def as_json(_options = {})
    {
      name:              name,
      screen_name:       screen_name,
      profile_image_url: profile_image_url_https,
      status_count:      statuses.count,
      followee_count:    followees.count
    }
  end

  def status_newest_in_tweeted_time
    statuses.newest_in_tweeted_time
  end

  def has_any_status?
    statuses.exists?
  end
end
