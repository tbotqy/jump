# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder

OmniAuth.config.logger = Rails.logger
