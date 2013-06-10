# -*- coding: utf-8 -*-
class Status < ActiveRecord::Base

  belongs_to :user
  has_many :entities, :dependent => :delete_all
  default_scope where(:pre_saved => false)

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

  def self.get_latest_status(user_id,limit)
    self.includes(:user,:entities).where(:user_id => user_id).order('twitter_created_at DESC').limit(limit)
  end

  def self.get_older_status(user_id,threshold_unixtime,limit = 10)
     self.includes(:user,:entities).where('statuses.user_id = ? AND statuses.twitter_created_at < ?',user_id,threshold_unixtime).order('twitter_created_at DESC').limit(limit)
  end
 
  def self.get_status_with_date(user,date,limit)
    
  end

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

end
