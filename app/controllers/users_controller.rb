# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :check_login
  before_filter :check_tweet_import

  def setting
    @title = "データ管理"
    @count_statuses = @current_user.statuses.count
    @count_friends = @current_user.friends.count
    @status_updated_at = Time.zone.at(@current_user.statuses_updated_at).strftime('%F %T')

    @friend_updated_at = @current_user.friends_updated_at
    if @friend_updated_at == 0
      @friend_updated_at = "---"
    else
      @friend_updated_at = Time.zone.at(@friend_updated_at).strftime('%F %T')
    end
    @profile_updated_at = Time.zone.at(@current_user.updated_at).strftime('%F %T')
  end

  def delete_account
  end

end
