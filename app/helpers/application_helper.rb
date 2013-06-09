# -*- coding: utf-8 -*-
module ApplicationHelper
  include Twitter::Autolink
  
  def logged_in?
    session[:user_id] ? true : false
  end

  def title(given_title = nil)
    base_title = configatron.site_name
    if given_title.nil?
      base_title
    else
      given_title + " - " + base_title
    end
  end

  def calc_tweet_posted_time(dest_unixtime,utc_offset,force_full_format = false)
    dest_unixtime += utc_offset
    
    dest_year = Time.at(dest_unixtime).strftime('%Y%').to_i
    current_year = Time.now.strftime('%Y').to_i

    format = current_year > dest_year || force_full_format ? '%Y年%-m月%-d日' : '%-m月%-d日'
    
    Time.at(dest_unixtime).strftime( format )
  end

  def linkify_tweet_body(tweet_body,entities_from_api)
    #return tweet_body if entities_from_api.empty?
   
    # linkify urls obeying Twitter display requirements
    entities_from_api.each do |entity|
      if entity.url
        tweet_body.gsub!(entity.url,'<a href="'+entity.url+'" target="_blank">'+entity.display_url+'</a>')
      end
    end

    # linkify user mentions
    tweet_body.gsub!(/@(\w+)/,"<a href=\"https://twitter.com/\\1\" target=\"_blank\">@\\1</a>")

    # linkify hashtags
    tweet_body.gsub!(/ #(\w+)/,"<a href=\"http://twitter.com/search?q=%23\\1\" target=\"_blank\"> #\\1</a>")

    tweet_body
  end
end
