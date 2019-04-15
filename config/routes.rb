# frozen_string_literal: true

Jump::Application.routes.draw do
  constraints SidekiqDashboardConstraint.new do
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get "sign_in",  to: "devise/sessions#new",     as: :new_user_session
    get "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  root to: "pages#service_top"
  get "/for_users", to: "pages#for_users"

  get "/users/setting", to: "users#setting"
  get "/users/delete_account", to: "users#delete_account"

  get "/statuses/import",            to: "statuses#import"
  get "/user_timeline/(:date)",      to: "statuses#user_timeline",   as: :user_timeline
  get "/home_timeline/(:date)",      to: "statuses#home_timeline",   as: :home_timeline
  get "/public_timeline/(:date)",    to: "statuses#public_timeline", as: :public_timeline

  post "/ajax/check_profile_update", to: "ajax#check_profile_update"
  post "/ajax/check_friend_update",  to: "ajax#check_friend_update"
  post "/ajax/deactivate_account",   to: "ajax#deactivate_account"
  post "/ajax/delete_status",        to: "ajax#delete_status"
  post "/ajax/read_more",            to: "ajax#read_more"
  get  "/ajax/term_selector",        to: "ajax#term_selector"
  post "/ajax/make_initial_import",  to: "ajax#make_initial_import"
  post "/ajax/start_tweet_import",   to: "ajax#start_tweet_import"
  post "/ajax/check_import_progress", to: "ajax#check_import_progress"
  get  "/ajax/switch_term",          to: "ajax#switch_term"

  get  "*path", to: "application#render_404"
end
