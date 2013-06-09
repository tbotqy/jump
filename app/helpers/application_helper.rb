# -*- coding: utf-8 -*-
module ApplicationHelper

  def title(given_title = nil)
    base_title = configatron.site_name
    if given_title.nil?
      base_title
    else
      given_title + " - " + base_title
    end
  end

  def calc_tweet_posted_time(dest_unixtime,utc_offset)
    dest_unixtime += utc_offset
    
    dest_year = Time.at(dest_unixtime).strftime('%Y%').to_i
    current_year = Time.now.strftime('%Y').to_i

    format = current_user > dest_year ? '%Y年%-m月%-d日' : '%-m月%-d日'
    
    Time.at(dest_unixtime).strftime( format )
  end

end
