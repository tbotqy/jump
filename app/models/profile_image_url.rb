# -*- coding: utf-8 -*-
class ProfileImageUrl < ActiveRecord::Base
  scope :unapplied ,-> {where(:applied_to_status => false)}
  scope :valid_url,-> {where(:is_valid_url => true)}

  class << self
    def sync_record_with_status_broken
      # fetch and save screen_name marked as unsolved the invalid url
      progress_bar = ProgressBar.create(:total => Status::Broken.unsolved.count,:format => "%t |%B| %P[%],%a,%E(%c/%C)")
      Status::Broken.unsolved.each do |broken_status|
        # fetch screen_name from Status and save
        screen_name = Status.find(broken_status.status_id).rt_screen_name
        unless where(:screen_name => screen_name).exists?
          create(
          :twitter_id => nil,
          :screen_name => screen_name,
          :url => nil,
          :is_valid_url => false
          )
        end
        progress_bar.increment
      end
      puts "Done."
    end

    def save_valid_url
      # fetch fresh url via API and save

      twitter = Twitter::Client.new
      puts "Fetching the records to fill..."
      records_to_fill = where(:is_valid_url => false)

      progress_bar = ProgressBar.create(:total => records_to_fill.count,:format => "%t |%B| %P[%],%a,%E(%c/%C)")
      records_to_fill.select(:screen_name).pluck(:screen_name).each_slice 100 do |dest_screen_names|
        # fetch fresh user data via API and update url
        begin
          twitter_users = twitter.users(dest_screen_names)
        rescue Twitter::Error::TooManyRequests => error
          progress_bar.log  "Too many requests error occured. Sleep for #{error.rate_limit.reset_in} at #{Time.now} ..."
          sleep error.rate_limit.reset_in
          progress_bar.log "Retrying..."
          retry
        rescue Twitter::Error => error
          #progress_bar.log "No user was returned from API. Trying next 100 screen names..."
          progress_bar.progress += dest_screen_names.size
          next
        else
          #progress_bar.log "User found on Twitter.Saving their twitter id and prof-url..."
          twitter_users.each do |user_twitter|
            # save urls
            find_by_screen_name(user_twitter.screen_name).update_attributes(
            :twitter_id => user_twitter.id,
            :url => user_twitter.profile_image_url_https,
            :is_valid_url => true
            )
            progress_bar.increment
          end
          (dest_screen_names.size - twitter_users.size).times { progress_bar.increment }
        end
      end
      puts "Done."
    end

    def apply_fresh_url_to_statuses
      # 仮 only for retweet
      fresh_records = valid_url
      progress_bar = ProgressBar.create(:total => fresh_records.count,:format => "%t |%B| %P[%],%a,%E(%c/%C)")
      fresh_records.each do |fresh_record|
        Status.where(:rt_screen_name => fresh_record.screen_name).update_all(:rt_profile_image_url_https => fresh_record.url)
        valid_url.where(:screen_name).update_all(:applied_to_status => true)
        progress_bar.increment
      end
      puts "Done."
    end

    def _apply_fresh_url_to_statuses
      unapplied.each do |unapplied_record|
        case unapplied_record.is_retweet
        when true
          Status.find_by_status_id(unapplied_record.status_id).update_attributes(:rt_profile_image_url_https => unapplied_record.url)
        when false
          Status.find_by_status_id(unapplied_record.status_id).update_attributes(:profile_image_url_https => unapplied_record.url)
        end
        unapplied_record.update_attributes(:applied_to_status_ => true)
      end
    end
  end
end
