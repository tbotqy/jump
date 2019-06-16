# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  direct :user_timeline do
    "/user_timeline"
  end

  direct :status_import do
    "/statuses/import"
  end
end
