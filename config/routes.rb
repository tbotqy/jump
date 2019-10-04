# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "sign_out", to: "devise/sessions#destroy"
  end

  direct :user_timeline do
    "#{Settings.frontend.url}/user_timeline"
  end

  direct :status_import do
    "#{Settings.frontend.url}/import"
  end

  direct :service_top do
    Settings.frontend.url
  end

  resource :stats, only: %i|show|

  resources :statuses, only: %i|index|

  resources :tweeted_dates, only: %i|index|

  get :me, to: "users#me"
  get "/users/:screen_name", to: "users#show", as: :user_page

  resources :users, only: %i|index destroy| do
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
