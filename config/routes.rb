# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get "sign_out", to: "devise/sessions#destroy"
  end

  direct :user_timeline do
    "/user_timeline"
  end

  direct :status_import do
    "/statuses/import"
  end

  resources :statuses, only: %i|index|

  resources :users, only: %i|show destroy| do
    scope module: :users do
      resources :statuses,          only: %i|index create|
      resources :followee_statuses, only: %i|index|
      resource  :import_progress,   only: %i|show|
    end
  end
end
