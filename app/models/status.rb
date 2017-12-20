class Status < ActiveRecord::Base

  belongs_to :user
  has_many :entities, :dependent => :delete_all
  scope :showable , -> {where(:pre_saved => false,:deleted_flag => false)}
  scope :retweet , -> {where(:is_retweet => true)}
  scope :order_for_timeline , ->{order("twitter_created_at_reversed ASC","status_id_str_reversed ASC")}
  scope :order_for_date_list, ->{order("twitter_created_at_reversed ASC")}
  scope :use_index , ->(index_name) {from("#{table_name} USE INDEX(#{index_name})")}
  scope :force_index , ->(index_name) {from("#{table_name} FORCE INDEX(#{index_name})")}
  after_save :update_user_timestamp

  def update_user_timestamp
    user.update_attribute(:statuses_updated_at, Time.now.to_i)
  end

  class << self
    def delete_pre_saved_status(user_id)
      destroy_all(user_id: user_id, pre_saved: true)
    end

    def save_pre_saved_status(user_id)
      where(user_id: user_id, pre_saved: true).update_all(pre_saved: false)
    end

    def save_statuses(user_id,tweets)
      tweets.each do |tweet|
        save_single_status(user_id,tweet)
      end
    end

    def save_single_status(user_id,tweet)
      new_record = Status.create( create_hash_to_save(user_id,tweet) )

      # also save the entity belongs to the tweet
      Entity.save_entities(new_record.id.to_i,tweet)

      # save status's created_at values
      PublicDate.add_record(Time.parse(tweet.attrs[:created_at]).to_i)
    end

    def get_date_list(type_of_timeline,user_id = nil)
      unixtime_list = get_twitter_created_at_list(type_of_timeline,user_id)
      seriarize_unixtime_list(unixtime_list)
    end

    def seriarize_unixtime_list(unixtime_list)

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

    def get_twitter_created_at_list(type_of_timeline,user_id = nil)
      case type_of_timeline
      when 'sent_tweets'
        select(:twitter_created_at_reversed).group(:twitter_created_at_reversed).owned_by_current_user(user_id).order_for_timeline.pluck(:twitter_created_at_reversed)
      when 'home_timeline'
        select(:twitter_created_at_reversed).group(:twitter_created_at_reversed).owned_by_friend_of(user_id).order_for_date_list.pluck(:twitter_created_at_reversed)
        #select(:twitter_created_at_reversed).uniq.owned_by_friend_of(user_id).pluck(:twitter_created_at_reversed)
      when 'public_timeline'
        PublicDate.get_list.pluck(:posted_unixtime)
      end
    end

    # get methods for retrieving timeline

    def get_latest_status(limit = 10)
      includes(:user,:entities).limit(limit).order_for_timeline
    end

    def get_status_in_date(date = "YYYY(/MM(/DD))",limit = 10)
      # search the statuses tweeted in given date

      # calculate the beginning and ending time of given date in unixtime
      date = calc_from_and_to_of(date)
      includes(:user,:entities).where(twitter_created_at_reversed: -1*date[:to]..-1*date[:from]).limit(limit).order_for_timeline
    end

    def get_older_status_by_tweet_id(threshold_tweet_id,limit = 10)
      # search the statuses whose status_id_str is smaller than given threshold_tweet_id
      # used to proccess read more button's request
      # use status_id_str_reversed in order to search by index
      threshold_tweet_id_revered = -1*threshold_tweet_id.to_i
      includes(:user).where('statuses.status_id_str_reversed > ?',threshold_tweet_id_revered).limit(limit).order(:status_id_str_reversed)
    end

    # methods to define whose tweets to be searched

    def owned_by_current_user(user_id)
      # used for users#sent_tweets
      where(user_id: user_id)
    end

    def owned_by_friend_of(user_id)
      # used for users#home_timeline
      friend_user_ids = Friend.get_friend_user_ids(user_id)
      where('user_id IN (?)',friend_user_ids)
    end

    def get_active_status_count
      DataSummary.get_value_of("active_status_count")
    end

    # utils

    private

    def create_hash_to_save(user_id,tweet)
      ret = {}
      tweet = tweet.attrs

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

    def calc_from_and_to_of(date)
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
  end
end
