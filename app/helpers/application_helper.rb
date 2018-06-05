module ApplicationHelper
  def logged_in?
    session[:user_id] ? true : false
  end

  def title_text
    site_name = configatron.site_name

    return content_for(:title) + " - " + site_name if content_for(:title)
    site_name
  end

  def calc_tweet_posted_time(dest_unixtime, force_full_format = false, show_minute = false)
    dest_year = Time.zone.at(dest_unixtime).strftime('%Y').to_i
    current_year = Time.zone.now.strftime('%Y').to_i

    format = current_year > dest_year || force_full_format ? '%Y年%-m月%-d日' : '%-m月%-d日'
    format += " %-H:%M" if show_minute

    Time.zone.at(dest_unixtime).strftime( format )
  end

  def calc_relative_timestamp(dest_unixtime)
    # calculate how long has it passed since dest_unixtime
    # and returns timestamp for tweet in appropriate format, that is same with twitter

    current_time = Time.now.to_i
    diff = current_time - dest_unixtime

    if dest_unixtime.between?(1.minute.ago.to_i, current_time) # less than 1 minute
      return diff.to_s + "秒"
    elsif dest_unixtime.between?(1.hour.ago.to_i, current_time) # less than 1 hour
      return (diff / 60).to_s + "分"
    elsif dest_unixtime.between?(1.day.ago.to_i, current_time) # less than 1 day
      # obeys view behavior in twitter
      # 2.4 hour is shown as 2 hour
      # 2.5 hour is shown as 3 hour
      return (diff/3600).round.to_s + "時間"
    elsif dest_unixtime.between?(1.year.ago.to_i, current_time) # less than 1 year
      return Time.zone.at(dest_unixtime).strftime("%-m月%-d日")
    else
      return Time.zone.at(dest_unixtime).strftime("%Y年%-m月%-d日")
    end
  end

  def linkify_tweet_body(tweet_body,entities_from_api)
    return tweet_body if entities_from_api.empty?

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
