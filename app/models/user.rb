class User < ActiveRecord::Base

  has_many :statuses, :dependent => :destroy
  has_many :friends, :dependent => :delete_all
  
  def has_friend?
    Friend.exists?(:user_id=>self.id)
  end

  def has_imported?
    # check if user has imported own tweets
    self.initialized_flag
  end

  def has_any_status?
    Status.unscoped.where(:user_id => self.id).present?
  end

  def get_oldest_active_tweet_id
    Status.select(:status_id_str).where(:user_id => self.id).reorder('status_id_str ASC').limit(1)[0].status_id_str rescue "false"
  end

  def get_active_status_count
    Status.where(:user_id => self.id).count
  end

  def self.create_account(auth)
    return false unless auth.instance_of?(OmniAuth::AuthHash)

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
      :token_updated_at => false,
      :statuses_updated_at => false,
      :friends_updated_at => false,
      :closed_only => false,
      :initialized_flag => false,
      :deleted_flag => false,
      :created_at => Time.zone.now.to_i,
      :updated_at => Time.zone.now.to_i
      )

    user.save
  end

  def self.update_account(auth)
    return false unless auth.instance_of?(OmniAuth::AuthHash)

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
        :token_updated_at => true,
        :updated_at => Time.zone.now.to_i
      })
  end

  def self.deactivate_account(user_id)
    # just turn the flag off, not actually delete account from database
    self.find(user_id).update_attribute(:deleted_flag,true)
    Status.where(:user_id => user_id).update_all(:deleted_flag => true)
  end

  def self.active_twitter_id_exists?(twitter_id)
    # check if user exists by searching given twitter id
    self.where(:twitter_id => twitter_id).where(:deleted_flag => false).exists?
  end

  def self.get_active_users
    self.where(:deleted_flag => false).order('created_at DESC')
  end

  def self.get_active_user_count
    self.select(:id).where(:deleted_flag => false).count
  end
  
  def self.get_gone_users
    self.where(:deleted_flag => true).order('updated_at DESC')
  end
end
