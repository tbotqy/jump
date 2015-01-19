Tlviewer::Application.routes.draw do
  match "/browsers" => "users#browsers"
  match "/for_users" => "users#for_users"
  match "/auth/twitter/callback" => "logs#login"
  match "/auth/failure" => "logs#logout"
  match "/statuses/import" => "statuses#import" 
  match "/your/tweets/(:date)" => "users#sent_tweets"
  match "/your/home_timeline/(:date)" => "users#home_timeline"
  match "/your/data" => "users#setting"
  match "/public_timeline/(:date)" => "users#public_timeline"
  match "/logout" => "logs#logout"
  match "/admin/accounts" => "admin#accounts"
  match "/admin/statuses" => "admin#statuses"
  match "/sorry" => "logs#sorry"
  root :to => 'users#index'
  match ':controller(/:action(/:id))(.:format)'
end
