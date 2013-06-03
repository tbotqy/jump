class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_vars

  def set_vars
    # set vars only if reqeust is not Ajax
    unless request.xhr?
      @show_footer = true
    end
  end
end
