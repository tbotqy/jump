class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_vars

  def set_vars
    # set vars only if reqeust is not Ajax
    unless request.xhr?
      # implement later
      @show_footer = true
      @logged_in = false
      @user_is_initialized = false
      @logging_user = false
    end
  end
end
