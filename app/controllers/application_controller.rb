# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector

  protect_from_forgery

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

  def check_tweet_import
    return if current_user&.finished_initial_import?
    redirect_to controller: "statuses", action: "import"
  end
end
