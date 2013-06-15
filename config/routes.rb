Tlviewer::Application.routes.draw do

  match "/auth/twitter/callback" => "logs#login"
  match "/statuses/import" => "statuses#import" 
  match "/your/tweets/(:date)" => "users#sent_tweets"
  match "/your/home_timeline/(:date)" => "users#home_timeline"
  match "/your/data" => "users#setting"
  match "/public_timeline/(:date)" => "users#public_timeline"
  match "/logout" => "logs#logout"
  match "/admin/accounts" => "admin#accounts"
  match "/admin/statuses" => "admin#statuses"
  root :to => 'users#index'
  match ':controller(/:action(/:id))(.:format)'
end
