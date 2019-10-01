# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i|twitter|

  has_many :statuses,              dependent: :destroy
  has_many :followees,             dependent: :delete_all
  has_one  :tweet_import_progress, dependent: :destroy
  has_one  :tweet_import_lock,     dependent: :destroy
  has_many :user_update_fail_logs, dependent: :delete_all

  has_many :hashtags, through: :statuses
  has_many :urls,     through: :statuses
  has_many :media,    through: :statuses

  validates :uid,                 presence: true, uniqueness: true, length: { maximum: 255 }
  validates :twitter_id,          presence: true, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :provider,            presence: true, length: { maximum: 255 }
  validates :name,                presence: true, length: { maximum: 255 }
  validates :screen_name,         presence: true, length: { maximum: 255 }
  validates :protected_flag_before_type_cast, inclusion: { in: [1, 0, true, false] }
  validates :avatar_url,          presence: true, length: { maximum: 255 }
  validates :profile_banner_url,  allow_nil: true, length: { maximum: 255 }
  validates :twitter_created_at,  presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :access_token,        presence: true, length: { maximum: 255 }
  validates :access_token_secret, presence: true, length: { maximum: 255 }
  validates :token_updated_at,    numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :statuses_updated_at, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  scope :not_protected, -> { where(protected_flag: false) }

  class << self
    def register_or_update!(provider:, uid:, twitter_id:, twitter_created_at:, name:, screen_name:, protected_flag:, avatar_url:, profile_banner_url:, access_token:, access_token_secret:)
      user = find_or_initialize_by(uid: uid)
      user.update!(
        twitter_id:          twitter_id,
        provider:            provider,
        name:                name,
        screen_name:         screen_name,
        protected_flag:      protected_flag,
        avatar_url:          avatar_url,
        profile_banner_url:  profile_banner_url,
        twitter_created_at:  Time.zone.parse(twitter_created_at).to_i,
        access_token:        access_token,
        access_token_secret: access_token_secret
      )
      user
    end

    def find_latest_by_screen_name!(screen_name)
      where(screen_name: screen_name).order(updated_at: :asc).last!
    end
  end

  def as_json(_options = {})
    _statuses_updated_at  = statuses_updated_at.nil? ? nil : Time.zone.at(statuses_updated_at).iso8601
    _followees_updated_at = followees.last&.created_at&.iso8601
    {
      id:             id,
      name:           name,
      screen_name:    screen_name,
      avatar_url:     avatar_url,
      profile_banner_url: profile_banner_url,
      protected_flag: protected_flag,
      status_count:   statuses.count.to_s(:delimited),
      followee_count: followees.count.to_s(:delimited),
      statuses_updated_at:  _statuses_updated_at,
      followees_updated_at: _followees_updated_at
    }
  end

  def has_any_status?
    statuses.exists?
  end

  def admin?
    twitter_id === Settings.admin_user_twitter_id
  end

  # defined for development purpose
  def tokens
    { access_token: access_token, access_token_secret: access_token_secret }
  end
end
