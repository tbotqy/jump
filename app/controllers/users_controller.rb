# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_tweet_import

  def setting
    @view_object = UsersViewObject::Setting.new(current_user)
  end

  def delete_account
  end

  def sentry_test
    User.foo
  end
end
