class UsersController < ApplicationController
  before_action :check_login
  before_action :check_tweet_import

  def setting
    @view_object = UsersViewObject::Setting.new(@current_user)
  end

  def delete_account
  end
end
