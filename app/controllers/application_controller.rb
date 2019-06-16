# frozen_string_literal: true

class ApplicationController < ActionController::API
  # including this because ActionController::API doesn't implement #respond_to
  # , which is required for Devise::SessionsController#sign_out to work without raising NoMethodError.
  # TODO: implement sign_out without using ::API controller
  include ActionController::MimeResponds
end
