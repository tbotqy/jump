# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector

  protect_from_forgery

  before_action :apply_user_time_zone, :reject_incompatible_ua
  rescue_from Exception, with: :render_500 if Rails.env.production?

  def render_404(exception = nil)
    render_error(exception, 404)
  end

  def render_500(exception = nil)
    render_error(exception, 500)
  end

  def render_error(e, status_code)
    if e.present?
      Rails.logger.error(e.message)
      Raven.capture_exception(e)
    end
    render file: "errors/#{status_code}", status: status_code, layout: "error", content_type: "text/html"
  end

  def available_ua?
    # reject msie whose version is not 9
    ua = request.env["HTTP_USER_AGENT"].to_s
    return false if ua.include?("MSIE") && ua.include?("9.0")
    true
  end

  def reject_incompatible_ua
    return if request.xhr? || params[:action] == "browsers"
    return if available_ua?
    redirect_to controller: "users", action: "browsers"
  end

  def apply_user_time_zone
    if current_user
      Time.zone = current_user.time_zone
    else
      Time.zone = cookies[:timezone] || "UTC"
    end
  end

  def check_tweet_import
    return if current_user&.finished_initial_import?
    redirect_to controller: "statuses", action: "import"
  end
end
