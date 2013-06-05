class UsersController < ApplicationController

  before_filter :check_login, :except => ["index","callback"]
  before_filter :check_tweet_import, :except => ["index","callback"]

  def index

    # check if user is logged in
    if @logged_in
      redirect_to :action => "home_timeline"
    else
      @show_footer = true
      @total_status_num = Status.get_total_status_num
    end

  end
  
  def home_timeline
    raise "welcome!"
  end

end
