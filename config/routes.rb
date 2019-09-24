require "sidekiq/web"
require "sidekiq/cron/web"

# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "sign_out", to: "devise/sessions#destroy"
  end

  direct :user_timeline do
    "#{Settings.frontend_host}/user_timeline"
  end

  direct :status_import do
    "#{Settings.frontend_host}/import"
  end

  direct :service_top do
    Settings.frontend_host
  end

  resources :statuses, only: %i|index|

  resources :tweeted_dates, only: %i|index|

  resources :users, only: %i|show destroy| do
    scope module: :users do
      resources :statuses,              only: %i|index create|
      put "statuses",                   to: "statuses#update"
      resources :tweeted_dates,         only: %i|index|
      resources :followees,             only: %i|create|
      resource  :tweet_import_progress, only: %i|show|

      namespace :followees do
        resources :statuses,      only: %i|index|
        resources :tweeted_dates, only: %i|index|
      end
    end
  end

  authenticate :user, -> user { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
