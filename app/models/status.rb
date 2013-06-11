# -*- coding: utf-8 -*-
class Status < ActiveRecord::Base

  belongs_to :user
  has_many :entities, :dependent => :delete_all
  default_scope where(:pre_saved => false).order('twitter_created_at DESC')

  def self.get_total_status_num
    self.count
  end
  
  def self.delete_pre_saved_status(user_id)
    self.delete_all(:user_id => user_id, :pre_saved => true)
  end

  def self.save_pre_saved_status(user_id)
    self.where(:user_id => user_id, :pre_saved => true).update_all(:pre_saved => false)
  end

  def self.save_statuses(user_id,tweets)
    tweets.each do |tweet|
      new_record = Status.create( self.create_hash_to_save(user_id,tweet) )
      
      # also save the entity belongs to the tweet
      Entity.save_entities(new_record.id.to_i,tweet)
        
      # save status's created_at value to the table of its list
      PublicDate.add_record(Time.parse(tweet[:attrs][:created_at]).to_i)
    end
  end
  
  # get methods for retrieving timeline

  def self.get_latest_status(limit = 10)
    self.limit(limit)
  end

  def self.get_status_between(dates,limit = 10)
    # used to create the timeline with term to include specified
    date = calc_from_and_to_of(dates)
    self.where('statuses.twitter_created_at >= ? AND statuses.twitter_created_at <= ?',date[:from],date[:to]).limit(limit)
  end

  def self.get_status_older_than(threshold_unixtime,limit)
    # used to proccess read more button's request
    self.where('statuses.twitter_created_at <= ?',threshold_unixtime).limit(limit)
  end

  def self.owned_by_current_user(user_id)
    # used for users#sent_tweets
    self.where('statuses.user_id = ?',user_id)
  end

  def self.owned_by_friend_of(user_id)
    # used for users#home_timeline
    friend_ids = Friend.select(:following_twitter_id).where(:user_id => user_id)
    self.where('statuses.twitter_id IN (?)',friend_ids.pluck(:following_twitter_id))
  end

  def self.owned_by_active_user
    # used for users#public_timeline
    active_user_ids = User.where(:deleted_flag => false)
    self.where('statuses.user_id IN (?)',active_user_ids)
  end

  # utils

  private
  def self.create_hash_to_save(user_id,tweet)
    ret = {}
    tweet = tweet[:attrs]
    
    ret[:user_id] = user_id
    ret[:twitter_id] = tweet[:user][:id_str]
    ret[:status_id_str] = tweet[:id_str]
    ret[:in_reply_to_status_id_str] = tweet[:in_reply_to_status_id_str]
    ret[:in_reply_to_user_id_str] = tweet[:in_reply_to_user_id_str]
    ret[:in_reply_to_screen_name] = tweet[:in_reply_to_screen_name]
    ret[:place_full_name] = tweet[:place].nil? ? nil : tweet[:place][:full_name]
    ret[:retweet_count] = tweet[:retweet_count]
    ret[:twitter_created_at] = Time.parse(tweet[:created_at].to_s).to_i
    ret[:source] = tweet[:source]
    ret[:text] = tweet[:text]
    ret[:possibly_sensitive] = tweet[:possibly_sensitive] || false
    ret[:pre_saved] = true
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
    case parts.size
    when 1 # only year is specified
      ret[:from] = DateTime.new(year).beginning_of_year.to_i
      ret[:to] = DateTime.new(year).end_of_year.to_i
    when 2 # year and month is specified
      ret[:from] = DateTime.new(year,month).beginning_of_month.to_i
      ret[:to] = DateTime.new(year,month).end_of_month.to_i
    when 3 # year and month and day is specified
      ret[:from] = DateTime.new(year,month,day).beginning_of_day.to_i
      ret[:to] = DateTime.new(year,month,day).end_of_day.to_i
    end

    ret
  end

end
