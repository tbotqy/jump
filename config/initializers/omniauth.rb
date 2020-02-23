# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder

OmniAuth.configure do |config|
  config.logger = Rails.logger
  config.allowed_request_methods = [:post]
end
