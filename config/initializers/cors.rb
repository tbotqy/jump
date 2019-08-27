# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [Settings.frontend_host]
    resource "*",
             methods: %i[get post put patch delete],
             headers: :any,
             credentials: true
  end
end
