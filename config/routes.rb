Jump::Application.routes.draw do
  get "/browsers" => "users#browsers"
  get "/for_users" => "users#for_users"
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
  get "/sorry" => "logs#sorry"
  root :to => 'users#index'
  get ':controller(/:action(/:id))(.:format)'
  get "*path" => "application#render_404"
end
