# -*- coding: utf-8 -*-
class Status < ActiveRecord::Base
  
  has_many :entity, :dependent => :delete_all
 
  def self.get_total_status_num
    self.count(
      :conditions => {
        :pre_saved => false
      }
      )
  end
  
  def self.delete_pre_saved_status(user_id)
    self.delete_all(:user_id => user_id, :pre_saved => true)
  end

  def self.save_pre_saved_status(user_id)
    self.where(:user_id => user_id,:pre_saved => true).update_attribute(:pre_saved => false)
  end

  def self.save_statuses(user,tweets)
    created_at = Time.now.to_i
    self.new do |i|
      tweets.each do |tweet|
        tweet = tweet[:attrs]
        i.user_id = user[:id]
        i.twitter_id = user[:twitter_id]
        i.status_id_str = tweet[:id_str]
        i.in_reply_to_status_id_str = tweet[:in_reply_to_status_id_str]
        i.in_reply_to_user_id_str = tweet[:in_reply_to_user_id_str]
        i.in_reply_to_screen_name = tweet[:in_reply_to_screen_name]
        i.place_full_name = tweet[:place].nil? ? nil : tweet[:place][:full_name]
        i.retweet_count = tweet[:retweet_count]
        i.twitter_created_at = Time.parse(tweet[:created_at].to_s).to_i
        i.source = tweet[:source]
        i.text = tweet[:text]
        i.possibly_sensitive = tweet[:possibly_sensitive] || false
        i.pre_saved = true
        i.created_at = created_at

        # check if this is the rewteeted status
        if tweet[:retweeted_status]
          rt = tweet[:retweeted_status]
          i.is_retweet = true
          i.rt_name = rt[:user][:name]
          i.rt_screen_name = rt[:user][:screen_name]
          i.rt_profile_image_url_https = rt[:user][:profile_image_url_https]
          i.rt_text = rt[:text]
          i.rt_source = rt[:source]
          i.rt_created_at = Time.parse(rt[:created_at]).to_i
        else
          i.is_retweet = false
          i.rt_name = nil
          i.rt_screen_name = nil
          i.rt_profile_image_url_https = nil
          i.rt_text = nil
          i.rt_source = nil
          i.rt_created_at = nil
        end

        i.save
        
        # also save the entity belongs to the tweet
        Entity.save_entities(@current_user,tweet)
        
        # save status's created_at value to the table of its list
        PublicDate.add_record(created_at)
          
      end

    end

   

  end

end
