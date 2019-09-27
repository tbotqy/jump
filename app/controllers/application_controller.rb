# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :reject_non_ajax!

  rescue_from RuntimeError,                 with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  rescue_from Errors::InvalidParam,         with: :render_400
  rescue_from Errors::InvalidRequestType,   with: :render_400
  rescue_from Errors::Unauthorized,         with: :render_401
  rescue_from Errors::NotFound,             with: :render_404

  private
    def authenticate_user!
      raise Errors::Unauthorized, "The request need authentication." unless user_signed_in?
    end

    def authorize_operation_for!(resource)
      unless current_user === resource
        raise Errors::InvalidParam, "Attempting to operate on other's resource."
      end
    end

    def render_400(e)
      render_error(e, 400)
    end

    def render_401(e)
      render_error(e, 401)
    end

    def render_404(e)
      render_error(e, 404, report: false)
    end

    def render_500(e)
      render_error(e, 500)
    end

    def render_error(e, status_code, report: true)
      Rails.logger.error(e.message)
      Raven.capture_exception(e) if report

      messages = e.try(:messages) || Array.wrap(e.message)
      render json: { messages: messages }, status: status_code
    end

    def reject_non_ajax!
      if !request.xhr?
        raise Errors::InvalidRequestType, "Requesting with an invalid request type."
      end
    end
end
