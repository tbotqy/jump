class UsersController < ApplicationController
  before_filter :check_login
  before_filter :check_tweet_import

  def setting
    @view_object = UsersViewObject::Setting.new(@current_user)
  end

  def delete_account
  end

end
