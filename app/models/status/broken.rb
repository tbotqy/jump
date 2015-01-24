class Status::Broken < ActiveRecord::Base
  attr_accessible :created_at, :state, :solved, :status_id, :updated_at
  scope :unsoleved, -> {where(:solved => false)}
  scope :invalid_profile_image_url, -> {where(:state => "invalid profile image url")}

  def self.record_invalid_profile_image_url_in_retweets(step = 100)
    puts "Checking existing records..."
    existing_record = self.invalid_profile_image_url
    unchecked_retweets = nil
    if existing_record.exists?
      last_checked_status_id = existing_record.maximum(:status_id)
      puts "Found existing record. Start checking with status.id = #{last_checked_status_id}"
    else
      puts "No existing record found."
      last_checked_status_id = 0
    end

    puts "Counting unchecked retweets..."
    unchecked_retweets = Status.showable.retweet.where("id > ?",last_checked_status_id).order("id ASC")
    count_unchecked_retweets = unchecked_retweets.count
    count_invalid = 0
    count_processed = 0
   
    puts "Starting check for #{count_unchecked_retweets} of unchecked retweets..."
    from = 0
    progress_bar_whole = ProgressBar.create(:title => "Detecting invalid prf-img(whole)",:total => count_unchecked_retweets,:format => "%t |%B| %P[%],%a,%E(%c/%C)")
    while( from < count_unchecked_retweets )
      limit = "#{from},#{step}"
      #puts "----- Starting query with limit #{limit} -----"
      unchecked_retweets_limited =  unchecked_retweets.limit(limit)
      count_limited = unchecked_retweets_limited.count
      #progress_bar_limited = ProgressBar.create(:title => "Detecting invalid prf-img(limited)",:total => count_limited,:format => "%t |%B| %P[%],%a,%E(%c/%C)")
      unchecked_retweets_limited.each.with_index do |unchecked_retweet,index|
        
        uri = URI.parse( URI.encode(unchecked_retweet.rt_profile_image_url_https) )
        begin
          res = Net::HTTP.get_response( uri.host, uri.path )
        rescue Timeout::Error => error
          self.create(:status_id => unchecked_retweet.id,:state => "invalid profile image url with Timeout::Error",:solved => false)
          count_invalid += 1
          next
        rescue Exception => error
          self.create(:status_id => unchecked_retweet.id,:state => "invalid profile image url with Exception",:solved => false)
          count_invalid += 1
          next
        else
          if res.code != "200"
            self.create(:status_id => unchecked_retweet.id,:state => "invalid profile image url",:solved => false)
            count_invalid += 1
          end
        end
        #progress_bar_limited.increment
        count_processed += 1
        progress_bar_whole.increment
      end
      
      #puts "Progress at [#{Time.now}] : #{((count_processed.to_f/count_unchecked_retweets.to_f)*100).round(2)} % done. #{count_invalid} statuses were recorded as invalid prof image retweet." if count_processed.modulo(100) == 0
      from += step
    end
    puts "Complete at #{Time.now} : Recorded #{count_invalid} invalid retweets."    
  end

  def self.fix_invalid_profile_image_in_retweet(step = 100)
    puts "Fetch fresh profile image url via API for each retweets in broken list"
    unsolved_list = Status::Broken.unsolved.invalid_profile_image_url
    
    count_unsolved =  unsolved_list.count
    count_processed = 0
    count_updated = 0
    count_skipped = 0
    
    twitter = create_twitter_client
    progress_bar_whole = ProgressBar.create(:title => "Fetch and update invalid prof-image(whole)",:total => count_unsolved,:format => "%t |%B| %P[%],%a,%E(%c)")
    from = 0
    while( from < count_unsolved )
      limit = "#{from},#{step}"
      #puts "Starting query with limit = #{limit}"
      unsolved_list.limit(limit).each.with_index do |unsolved_state,index|
        dest_status_id_str = Status.find(unsolved_state.status_id).status_id_str
        begin
          fresh_url = twitter.status(dest_status_id_str).retweet.user.profile_image_url_https 
        rescue Twitter::Error::NotFound => error
          unsolved_state.update_state(true,"skipped with NotFoundError")
          puts "Skipped with NotFoundError : status.id = #{unsolved_state.status_id}."
          count_skipped += 1
          next
        rescue Twitter::Error::Forbidden => error
          unsolved_state.update_state(true,"skipped with ForbiddenError")
          puts "Skipped with ForbiddenError : status.id = #{unsolved_state.status_id}."
          count_skipped += 1
          next
        rescue Twitter::Error::TooManyRequests => error
          puts "Too many requests error occured. Sleep for #{error.rate_limit.reset_in} at #{Time.now} ..."
          puts "Progress: [#{Time.now}] #{((count_processed.to_f/count_unsolved.to_f)*100).round(2)} % of records done. #{count_updated} statuses has been updated."
          sleep error.rate_limit.reset_in
          puts "Retrying..."
          retry
        rescue Twitter::Error => error
          unsolved_state.update_state(true,"skipped with Error")
          puts "Skipped with Error : status.id = #{unsolved_state.status_id}."
          count_skipped += 1
          next
        else
          dest_status = Status.find(unsolved_state.status_id)
          dest_status.update_attributes(:rt_profile_image_url_https => fresh_url)
          count_updated += 1
          unsolved_state.update_state(true,"")
        end
        progress_bar.increase
        count_processed += 1
      end
      from += step
      puts "Progress: [#{Time.now}] #{((count_processed.to_f/count_unsolved.to_f)*100).round(2)} % of records done. #{count_updated} statuses has been updated." if index.modulo(100) == 0
    end
    puts "Complete: updated #{count_updated} retweets / skipped (#{count_skipped}) are..."
    return count_updated
  end

  def update_state(solved_flag,state_string)
    update_attributes(:solved => solved_flag,:state => state_string)
  end

  private:
    def create_twitter_client
      Twitter::Client.new
    end

end

