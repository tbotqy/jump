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
    Status.where(:user_id => self.id).maximum(:status_id_str_reversed)*-1 rescue "false"
  end

  def get_active_status_count
    Status.where(:user_id => self.id,:deleted_flag => false).count
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

  def self.sync_profile_image
    puts "Collecting the user ids with invalid profile image url..."

    dest_twitter_ids = []
    count = 0
    self.get_active_users.each do |user_db|
      uri = URI.parse( URI.encode(user_db.profile_image_url_https) )
      res = Net::HTTP.get_response( uri.host, uri.path )
      if res.code != "200"
        # add the user's twitter id to array
        dest_twitter_ids.push(user_db.twitter_id)
        count += 1
      end
      puts "Progress : #{count} invalid urls found." if count.modulo(100) == 0 && count > 0
    end

    twitter = Twitter::Client.new

    puts "Fetching the latest profile image url and update..."
    count = 0
    dest_twitter_ids.each_slice 100 do |ids|
      twitter.users(ids).each do |user_twitter|
        # update prof image url
        self.find_by_twitter_id(user_twitter.id).update_attributes(:profile_image_url_https => user_twitter.profile_image_url_https)
        count += 1
      end
    end

    puts "Complete syncing #{count} users' profile image url."
  end

  def self.deactivate_account(user_id)
    # just turn the flag off, not actually delete user's status from database
    deleted_status_count = Status.where(:user_id => user_id).update_all(:deleted_flag => true)
    # update stats
    Stat.decrease('active_status_count',deleted_status_count)
    # turn the flag off for users table
    self.find(user_id).update_attribute(:deleted_flag,true)
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

  # maintenance methods --

  def self.delete_gone_users
    deleted_user_count = 0
    self.get_gone_users.each do |gone_user|
      if gone_user.destroy
        deleted_user_count += 1
      end
    end
    deleted_user_count
  end

  def self.delete_gone_and_duplicated_users
    # delete already-flagged users before process
    self.delete_gone_users

    # detect the duplicated user account
    duplicated_tids = []
    User.get_active_users.each do |u|
      count = self.where(:twitter_id => u.twitter_id).count
      if count > 1
        duplicated_tids.push(u.twitter_id)
      end
    end

    return 0 if duplicated_tids.size == 0

    # once flag all the duplicated users to deleted
    duplicated_tids.each do |tid|
      self.where(:twitter_id => tid).update_all(:deleted_flag => true)
    end
    # delete with group by used
    self.group(:twitter_id).each do |u|
      u.update_attributes(:deleted_flag => false)
    end

    # delete flagged users and return the number of them
    self.delete_gone_users

  end
end
