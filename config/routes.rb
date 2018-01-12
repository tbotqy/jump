Jump::Application.routes.draw do
  root to: 'pages#service_top'
  get '/for_users', to: 'pages#for_users'
  get '/browsers',  to: 'pages#browsers'
  get '/sorry',     to: 'pages#sorry'

  get '/auth/twitter/callback', to: 'session#login'
  get '/auth/failure',          to: 'session#logout'
  get '/logout',                to: 'session#logout'

  get '/your/data', to: 'users#setting'

  get '/statuses/import',            to: 'statuses#import'
  get '/your/tweets/(:date)',        to: 'statuses#sent_tweets'
  get '/your/home_timeline/(:date)', to: 'statuses#home_timeline'
  get '/public_timeline/(:date)',    to: 'statuses#public_timeline'

  get '/admin/accounts', to: 'admin#accounts'
  get '/admin/statuses', to: 'admin#statuses'

  post ':controller(/:action(/:id))(.:format)'
  get  ':controller(/:action(/:id))(.:format)'
  get  '*path', to: 'application#render_404'
end
