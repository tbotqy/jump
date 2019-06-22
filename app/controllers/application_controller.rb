# frozen_string_literal: true

class ApplicationController < ActionController::API
  # including this because ActionController::API doesn't implement #respond_to
  # , which is required for Devise::SessionsController#sign_out to work without raising NoMethodError.
  # TODO: implement sign_out without using ::API controller
  include ActionController::MimeResponds

  rescue_from RuntimeError,                 with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  rescue_from Errors::BadRequest,           with: :render_400
  rescue_from Errors::Unauthorized,         with: :render_401

  private
    def authenticate_user!
      raise Errors::Unauthorized, "The request need authentication." unless user_signed_in?
    end

    def render_400(e)
      render_error(e, 400)
    end

    def render_401(e)
      render_error(e, 401)
    end

    def render_404(e)
      render_error(e, 404)
    end

    def render_500(e)
      render_error(e, 500)
    end

    def render_error(e, status_code)
      Rails.logger.error(e.message)
      Raven.capture_exception(e)

      messages = e.try(:messages) || Array.wrap(e.message)
      render json: { messages: messages }, status: status_code
    end
end
