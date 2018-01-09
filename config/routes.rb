Jump::Application.routes.draw do
  get "/for_users", to: "pages#for_users"
  get "/browsers", to: "pages#browsers"
  get "/sorry", to: "pages#sorry"
  get "/auth/twitter/callback" => "session#login"
  get "/auth/failure" => "session#logout"
  get "/statuses/import" => "statuses#import"
  get "/your/tweets/(:date)" => "statuses#sent_tweets"
  get "/your/home_timeline/(:date)" => "statuses#home_timeline"
  get "/your/data" => "users#setting"
  get "/public_timeline/(:date)" => "statuses#public_timeline"
  get "/logout" => "session#logout"
  get "/admin/accounts" => "admin#accounts"
  get "/admin/statuses" => "admin#statuses"
  post ':controller(/:action(/:id))(.:format)'
  root :to => 'pages#service_top'
  get "*path" => "application#render_404"
end
