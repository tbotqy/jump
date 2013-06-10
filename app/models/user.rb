class User < ActiveRecord::Base

  has_many :statuses
  has_many :friends

  def self.create_account(auth)
    info = auth.extra.raw_info

    user = User.new(
      :twitter_id => info.id,
      :name => info.name,
      :screen_name => info.screen_name,
      :profile_image_url_https => info.profile_image_url_https,
      :time_zone => info.time_zone,
      :utc_offset => info.utc_offset,
      :twitter_created_at => Time.zone.parse(info.created_at).to_i,
      :lang => info.lang,
      :token => auth.credentials.token,
      :token_secret => auth.credentials.secret,
      :token_updated => false,
      :statuses_updated => false,
      :friends_updated => false,
      :closed_only => false,
      :initialized_flag => false,
      :deleted_flag => false,
      :twitter_created_at => Time.zone.now.to_i,
      :updated_at => Time.zone.now.to_i
      )

    user.save
  end

  def self.update_account(auth)
    dest_user = self.find_by_twitter_id(auth.uid)
    
    info = auth.extra.raw_info
    dest_user.update_attributes({
        :twitter_id => info.id,
        :name => info.name,
        :screen_name => info.screen_name,
        :profile_image_url_https => info.profile_image_url_https,
        :time_zone => info.time_zone,
        :utc_offset => info.utc_offset,
        :twitter_created_at => Time.zone.parse(info.created_at).to_i,
        :lang => info.lang,
        :token => auth.credentials.token,
        :token_secret => auth.credentials.secret,
        :token_updated => true,
        :updated_at => Time.zone.now.to_i
      })
  end

  def self.twitter_id_exists?(twitter_id)
    # check if user exists by searching given twitter id
    self.exists?(:twitter_id => twitter_id)
  end

  def has_imported?
    # check if user has imported own tweets
    self.initialized_flag
  end
end
