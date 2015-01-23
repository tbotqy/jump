class Status::Broken < ActiveRecord::Base
  attr_accessible :created_at, :current_state, :solved, :status_id, :updated_at
  scope :unsoleved, -> {where(:solved => false)}
  scope :broken_profile_image, -> {where(:current_state => "profile image is broken")}

  def self.record_broken_profile_image_retweets(step = 100)
    puts "Checking existing records..."
    existing_record = self.where(:current_state => "profile image is broken") 
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
          self.create(:status_id => unchecked_retweet.id,:current_state => "profile image is broken with Timeout::Error",:solved => false)
          count_invalid += 1
          next
        rescue Exception => error
          self.create(:status_id => unchecked_retweet.id,:current_state => "profile image is broken with some Http Error",:solved => false)
          count_invalid += 1
          next
        else
          if res.code != "200"
            self.create(:status_id => unchecked_retweet.id,:current_state => "profile image is broken",:solved => false)
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

  def update_state(solved_flag,state_string)
    update_attributes(:solved => solved_flag,:current_state => state_string)
  end

end

