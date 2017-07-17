# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :check_login,        except: :index
  before_filter :check_tweet_import, except: :index

  def index
    return redirect_to(action: :sent_tweets) if logged_in?

    @total_user_num   = User.active.count
    @total_status_num = DataSummary.active_status_count
  end

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
