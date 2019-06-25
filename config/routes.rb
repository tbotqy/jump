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

  resources :users, only: %i|show destroy| do
    resources :statuses, only: %i|index|, module: :users
  end
end
