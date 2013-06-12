# -*- coding: utf-8 -*-
class StatusesController < ApplicationController

  before_filter :check_login

  def import
    # show the screen for operating import method
    
    @title = "データの取り込み"

    # redirect initialized user
    if User.find(@@user_id).has_imported?
      redirect_to "/your/tweets" and return
    end
        
    # get the total number of tweets user has on twitter
    user_twitter = create_twitter_client.user(@@current_user.twitter_id)
    @statuses_count = user_twitter.attrs[:statuses_count]
  end

end
