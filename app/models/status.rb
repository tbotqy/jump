# -*- coding: utf-8 -*-
class Status < ActiveRecord::Base

  belongs_to :user
  has_many :entities, :dependent => :delete_all
  scope :showable , -> {where(:pre_saved => false,:deleted_flag => false)}
  scope :order_for_timeline , ->{order("twitter_created_at_reversed ASC","status_id_str_reversed ASC")}
  scope :order_for_date_list, ->{order("twitter_created_at_reversed ASC")}
  after_save :update_user_timestamp

  def self.record_invalid_profile_image_retweet(step = 100)
    puts "Checking if there is any progress..."
    undone_record = Record.where(:done => false).order("id DESC").first
    dest_statuses = nil
    count_dest_status = 0
    if undone_record
      latest_status_id = Status.showable.where(:status_id_str_reversed => -1*undone_record.status_id_str).order("id DESC").first.id
      dest_statuses = Status.showable.where("id < ?",latest_status_id).where(:is_retweet => true)
      puts "Latest record found: record id = #{undone_record.id}, created at #{Time.at(undone_record.created_at)}"
      sleep(3)
    else
      puts "No record saved yet."
      dest_statuses = Status.showable.where(:is_retweet => true)
    end
    puts "Check if progress is correctly checked..."
    puts "#{Status.showable.where(:is_retweet).count}(Retweets on statuses) = "
    puts "#{.count}(Retweets on records(undone) + #{Record.where(:done => true)} + #{
    count_invalid = 0
    count_processed = 0
    puts "Counting total num of destination statuses(unchecked retweets)..."
    count_dest_status  = dest_statuses.count
    puts "Starting loop for #{count_dest_status} of unchecked retweet statuses..."
    sleep(3)
    from = 0
    progress_bar = ProressBar.create(:total => count_dest_status)
    while( from < count_total_rts )
      limit = "#{from},#{step}"
      puts "----- Starting query with limit #{limit} -----"
      dest_statuses..order("id DESC").limit(limit).each.with_index do |status,index|
        uri = URI.parse( URI.encode(status.rt_profile_image_url_https) )
        res = Net::HTTP.get_response( uri.host, uri.path )
        if res.code != "200"
          Record.create(:status_id_str => status.status_id_str,:done => false)
          count_invalid += 1
        end
        count_processed += 1
        puts "Progress at [#{Time.now}] : #{((count_processed.to_f/count_desy_status.to_f)*100).round(2)} % done. #{count_invalid} statuses were recorded as invalid prof image retweet." if count_processed.modulo(100) == 0
        progress_bar.increment
      end
      from += step
    end
    puts "Complete at #{Time.now} : Recorded #{count_invalid} invalid retweets."
  end
  
  def self.sync_invalid_profile_image_in_record(from = nil,step = nil)
    puts "Fetch fresh profile image url via API for each retweets in Record"
    if !from && !srep
      limit = nil
    else
      limit = "#{from},#{step}"
    end
    count_total =  Record.where(:done => false).count
    count_updated = 0
    count_skipped = 0
    puts "Starting query with limit = #{limit}"
    Record.where(:done => false).limit(limit).each.with_index do |record,index|
      dest_status_id_str = record.status_id_str
      begin
        fresh_url = twitter.status(dest_status_id_str).retweet.user.profile_image_url_https 
      rescue Twitter::Error::NotFound => error
        Record.find_by_status_id_str(dest_status_id_str).update_attributes(:done=>true,:was_error=>true)
        puts "Skipped with NotFoundError : sidstr = #{dest_status_id_str}."
        count_skipped += 1
        next
      rescue Twitter::Error::Forbidden => error
        skipped_ids.push(dest_status_id_str)
        Record.find_by_status_id_str(dest_status_id_str).update_attributes(:done=>true,:was_error=>true)
        puts "Skipped with ForbiddenError: sidstr = #{dest_status_id_str}."
        count_skipped += 1
        next
      rescue Twitter::Error::TooManyRequests => error
        puts "Too many requests error occured. Sleep for #{error.rate_limit.reset_in} at #{Time.now} ..."
        puts "Progress: [#{Time.now}] #{((index.to_f/count_total.to_f)*100).round(2)} % of records done. #{count_updated} statuses has been updated."
        sleep error.rate_limit.reset_in
        puts "Retrying..."
        retry
      rescue Twitter::Error => error
        Record.find_by_status_id_str(dest_status_id_str).update_attributes(:done=>true,:was_error=>true)
        puts "Skipped with some error: sidstr = #{dest_status_id_str}."
        count_skipped += 1
        next
      else
        dest_status = Status.find_by_status_id_str_reversed(-1*dest_status_id_str.to_i)
        dest_status.update_attributes(:rt_profile_image_url_https => fresh_url)
        count += 1
        Record.find_by_status_id_str(dest_status_id_str).update_attributes(:done=>true,:was_error=>false)
        puts "Progress: [#{Time.now}] #{((index.to_f/count_total.to_f)*100).round(2)} % of records done. #{count_updated} statuses has been updated." if index.modulo(100) == 0
      end
    end

    puts "Complete: updated #{count_updated} retweets / skipped (#{count_skipped}) are..."
    return count_updated
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
