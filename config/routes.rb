Jump::Application.routes.draw do
  get "/for_users", to: "pages#for_users"
  get "/browsers", to: "pages#browsers"
  get "/sorry", to: "pages#sorry"
  get "/auth/twitter/callback" => "logs#login"
  get "/auth/failure" => "logs#logout"
  get "/statuses/import" => "statuses#import"
  get "/your/tweets/(:date)" => "users#sent_tweets"
  get "/your/home_timeline/(:date)" => "users#home_timeline"
  get "/your/data" => "users#setting"
  get "/public_timeline/(:date)" => "users#public_timeline"
  get "/logout" => "logs#logout"
  get "/admin/accounts" => "admin#accounts"
  get "/admin/statuses" => "admin#statuses"
  post ':controller(/:action(/:id))(.:format)'
  root :to => 'users#index'
  get ':controller(/:action(/:id))(.:format)'
  get "*path" => "application#render_404"
end
