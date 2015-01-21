# -*- coding: utf-8 -*-
class Status < ActiveRecord::Base

  belongs_to :user
  has_many :entities, :dependent => :delete_all
  scope :showable , -> {where(:pre_saved => false,:deleted_flag => false)}
  scope :order_for_timeline , ->{order("twitter_created_at_reversed ASC","status_id_str_reversed ASC")}
  scope :order_for_date_list, ->{order("twitter_created_at_reversed ASC")}
  after_save :update_user_timestamp

  def self.auto_sync_rt_prof(step = 100)
    from = 0
    step = step
    puts "Counting total num of retweet statuses..."
    dest_count = Status.showable.where(:is_retweet => true).count
    puts "Starting loop for #{dest_count} retweet statuses..."
    count_updated = 0
    while( from < dest_count )
      puts "----- Starting query with limit #{from},#{step} -----"
      count_updated += Status.sync_profile_image_in_retweet_by(nil,"#{from},#{step}")
      from += step
      puts "----- Progress : updated #{count_updated} retweets so far -----"
    end
    puts "----- Completed at #{Time.now}. Skipped #{dest_count - count_updated} retweets -----"
  end
    
  def self.sync_profile_image_in_retweet_by(owner_screen_name = nil,limit = nil)
    # collect retweets
    count_invalid = 0
    dest_status_id_strs = []
    #user_id = User.find_by_screen_name(owner_screen_name).id
    #Status.showable.where(:user_id => user_id).each do |status|
    Status.showable.where(:is_retweet => true).order("id").limit(limit).each do |status|
      if status.is_retweet?
        uri = URI.parse( URI.encode(status.rt_profile_image_url_https) )
        res = Net::HTTP.get_response( uri.host, uri.path )
        if res.code != "200"
          dest_status_id_strs.push(status.status_id_str)
          count_invalid += 1
          puts "Progress : #{count_invalid} statuses hit as invalid prof image. Current id is #{status.id}" if count_invalid.modulo(100) == 0
        end
      end
    end

    puts "Completed checking. Then fetch and update database for #{count_invalid} statuses..."
    count = 0
    skipped_ids = []
    twitter = Status.create_twitter
    dest_status_id_strs.each do |dest_status_id_str|
      begin
        fresh_url = twitter.status(dest_status_id_str).retweet.user.profile_image_url_https 
      rescue Twitter::Error::NotFound => error
        skipped_ids.push(dest_status_id_str)
        puts "Skipped with NotFoundError : sidstr = #{dest_status_id_str}."
        next
      rescue Twitter::Error::Forbidden => error
        skipped_ids.push(dest_status_id_str)
        puts "Skipped with ForbiddenError: sidstr = #{dest_status_id_str}."
        next
      rescue Twitter::Error::TooManyRequests => error
        puts "Too many requests error occured. Sleep for #{error.rate_limit.reset_in} at #{Time.now} ..."
        puts "Progress: #{((count.to_f/count_invalid.to_f)*100).round(2)} % of invalid retweets has been updated."
        sleep error.rate_limit.reset_in
        puts "Retrying..."
        retry
      rescue Twitter::Error => error
        skipped_ids.push(dest_status_id_str)
        puts "Skipped with some error: sidstr = #{dest_status_id_str}."
        next
      else
        dest_status = Status.find_by_status_id_str_reversed(-1*dest_status_id_str.to_i)
        dest_status.update_attributes(:rt_profile_image_url_https => fresh_url)
        count += 1
        puts "Progress: #{count} statuses has been updated." if count.modulo(50) == 0
      end
    end

    puts "Complete: updated #{count} retweets / skipped ids(#{skipped_ids.size}) are..."
    #skipped_ids
    return count
  end

  def self.detect_invalid_rt_profile_image
    # collect retweets
    count = 0
    Status.showable.where(:is_retweet => true).each do |status|
      uri = URI.parse( URI.encode(status.rt_profile_image_url_https) )
      res = Net::HTTP.get_response( uri.host, uri.path )
      if res.code != "200"
        count += 1
        puts "Progress : #{count} rt-statuses hit as invalid profile image. current sid = #{status.id}." if count.modulo(100) == 0
      end
    end
    puts "Complete counting : #{count} rt-statuses have invalid profile image."
  end

  def delete_flagged_status
    # delete all the statuses where deleted_flag = true
    Status.where(:deleted_flag => true).destroy_all
  end

  def flag_duplicated_status
    # turn the duplicated status's deleted_flag true
    
    # delete already-flagged statuses before this process
    delete_flagged_status
    
    puts "start flagging"
    User.get_active_users.each do |u|
      statuses  = Status.owned_by_current_user(u.id)
      # flag all the status's deleted flag true
      statuses.update_all(:deleted_flag => true)
      statuses.group("status_id_str_reversed").each do |s|
        s.update_attributes(:deleted_flag => false)
      end
      puts "flagged duplicated status of #{u.id}:#{u.screen_name}."
      sleep(1)
    end
    puts "Finished for all active users."
    true
  end

  def update_user_timestamp
    user_id = self.user_id
    User.find(user_id).update_attribute(:statuses_updated_at,Time.now.to_i)
  end

  def self.delete_pre_saved_status(user_id)
    self.destroy_all(:user_id => user_id, :pre_saved => true)
  end

  def self.save_pre_saved_status(user_id)
    self.where(:user_id => user_id, :pre_saved => true).update_all(:pre_saved => false)
  end

  def self.save_statuses(user_id,tweets)
    tweets.each do |tweet|
      self.save_single_status(user_id,tweet)
    end
  end

  def self.save_single_status(user_id,tweet)
    new_record = Status.create( self.create_hash_to_save(user_id,tweet) )
      
    # also save the entity belongs to the tweet
    Entity.save_entities(new_record.id.to_i,tweet)
    
    # save status's created_at values
    PublicDate.add_record(Time.parse(tweet[:attrs][:created_at]).to_i)
  end

  def self.get_date_list(type_of_timeline,user_id = nil)
    unixtime_list = self.get_twitter_created_at_list(type_of_timeline,user_id)
    self.seriarize_unixtime_list(unixtime_list)
  end

  def self.seriarize_unixtime_list(unixtime_list)
   
    # create 3D hash
    ret = Hash.new { |hash,key| hash[key] = Hash.new { |hash,key| hash[key] = {} } }
    
    unixtime_list.each do |t|
      t = t.abs
      y = Time.zone.at(t).year.to_s
      m = Time.zone.at(t).month.to_s
      d = Time.zone.at(t).day.to_s

      ret[y.to_s][m.to_s][d.to_s] = y+"-"+m+"-"+d
    end
    ret
  end

  def self.get_twitter_created_at_list(type_of_timeline,user_id = nil)
    case type_of_timeline
    when 'sent_tweets'
      self.select(:twitter_created_at_reversed).group(:twitter_created_at_reversed).owned_by_current_user(user_id).order_for_timeline.pluck(:twitter_created_at_reversed)
    when 'home_timeline'
      self.select(:twitter_created_at_reversed).group(:twitter_created_at_reversed).owned_by_friend_of(user_id).order_for_date_list.pluck(:twitter_created_at_reversed)
      #self.select(:twitter_created_at_reversed).uniq.owned_by_friend_of(user_id).pluck(:twitter_created_at_reversed)
    when 'public_timeline'
      PublicDate.get_list.pluck(:posted_unixtime)
    end
  end
  
  # get methods for retrieving timeline

  def self.get_latest_status(limit = 10)
    self.includes(:user,:entities).limit(limit).order_for_timeline
  end

  def self.get_status_in_date(date = "YYYY(/MM(/DD))",limit = 10)
    # search the statuses tweeted in given date
    
    # calculate the beginning and ending time of given date in unixtime
    date = calc_from_and_to_of(date)
    self.includes(:user,:entities).where(:twitter_created_at_reversed => -1*date[:to]..-1*date[:from]).limit(limit).order_for_timeline
  end

  def self.get_older_status_by_tweet_id(threshold_tweet_id,limit = 10)
    # search the statuses whose status_id_str is smaller than given threshold_tweet_id
    # used to proccess read more button's request
    # use status_id_str_reversed in order to search by index
    threshold_tweet_id_revered = -1*threshold_tweet_id.to_i
    self.includes(:user).where('statuses.status_id_str_reversed > ?',threshold_tweet_id_revered).limit(limit).order(:status_id_str_reversed)
  end

  # methods to define whose tweets to be searched

  def self.owned_by_current_user(user_id)
    # used for users#sent_tweets
    self.where(:user_id => user_id)
  end

  def self.owned_by_friend_of(user_id)
    # used for users#home_timeline
    friend_user_ids = Friend.get_friend_user_ids(user_id)
    self.where('user_id IN (?)',friend_user_ids)
  end

  def self.get_active_status_count
    Stat.get_value_of("active_status_count")
  end

  # utils

  private
  def self.create_hash_to_save(user_id,tweet)
    ret = {}
    tweet = tweet[:attrs]
    
    ret[:user_id] = user_id
    ret[:twitter_id] = tweet[:user][:id_str]
    ret[:status_id_str] = tweet[:id_str]
    ret[:status_id_str_reversed] = -1 * ret[:status_id_str].to_i
    ret[:in_reply_to_status_id_str] = tweet[:in_reply_to_status_id_str]
    ret[:in_reply_to_user_id_str] = tweet[:in_reply_to_user_id_str]
    ret[:in_reply_to_screen_name] = tweet[:in_reply_to_screen_name]
    ret[:place_full_name] = tweet[:place].nil? ? nil : tweet[:place][:full_name]
    ret[:retweet_count] = tweet[:retweet_count]
    ret[:twitter_created_at] = Time.parse(tweet[:created_at].to_s).to_i
    ret[:twitter_created_at_reversed] = -1*ret[:twitter_created_at]
    ret[:source] = tweet[:source]
    ret[:text] = tweet[:text]
    ret[:possibly_sensitive] = tweet[:possibly_sensitive] || false
    ret[:pre_saved] = true
    ret[:deleted_flag] = false
    ret[:created_at] = Time.now.to_i

    # check if this is the rewteeted status
    if tweet[:retweeted_status]
      rt = tweet[:retweeted_status]
    
      ret[:is_retweet] = true
      ret[:rt_name] = rt[:user][:name]
      ret[:rt_screen_name] = rt[:user][:screen_name]
      ret[:rt_profile_image_url_https] = rt[:user][:profile_image_url_https]
      ret[:rt_text] = rt[:text]
      ret[:rt_source] = rt[:source]
      ret[:rt_created_at] = Time.parse(rt[:created_at]).to_i
    else
      ret[:is_retweet] = false
      ret[:rt_name] = nil
      ret[:rt_screen_name] = nil
      ret[:rt_profile_image_url_https] = nil
      ret[:rt_text] = nil
      ret[:rt_source] = nil
      ret[:rt_created_at] = nil
    end

    ret
  end

  private
  def self.calc_from_and_to_of(date)
  # calculate the start/end date of given date in unixtime

    # detect the type of given date
    parts = date.to_s.split(/-/)
    
    year = parts[0].to_i
    month = parts[1].to_i
    day = parts[2].to_i
    
    ret = {}
    offset_rational =  Rational( Time.zone.utc_offset/3600,24)
    case parts.size
    when 1 # only year is specified
      ret[:from] = DateTime.new(year).new_offset( offset_rational ).beginning_of_year.to_i
      ret[:to] = DateTime.new(year).new_offset( offset_rational ).end_of_year.to_i
    when 2 # year and month is specified
      ret[:from] = DateTime.new(year,month).new_offset( offset_rational ).beginning_of_month.to_i
      ret[:to] = DateTime.new(year,month).new_offset( offset_rational ).end_of_month.to_i
    when 3 # year and month and day is specified
      ret[:from] = DateTime.new(year,month,day).new_offset( offset_rational ).beginning_of_day.to_i
      ret[:to] = DateTime.new(year,month,day).new_offset( offset_rational ).end_of_day.to_i
    end

    ret
  end

  def self.create_twitter
    # should move to helper
    Twitter::configure do |config|
      config.consumer_key = configatron.consumer_key
      config.consumer_secret = configatron.consumer_secret
    end
    Twitter::Client.new
  end

  def self.use_index(index_name)
    self.from("#{self.table_name} USE INDEX(#{index_name})")
  end

  def self.force_index(index_name)
    self.from("#{self.table_name} FORCE INDEX(#{index_name})")
  end
end
