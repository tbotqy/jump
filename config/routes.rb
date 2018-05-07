Jump::Application.routes.draw do
  root to: 'pages#service_top'
  get '/for_users', to: 'pages#for_users'
  get '/browsers',  to: 'pages#browsers'
  get '/sorry',     to: 'pages#sorry'

  get '/auth/twitter/callback', to: 'session#login'
  get '/auth/failure',          to: 'session#logout'
  get '/logout',                to: 'session#logout'

  get '/your/data', to: 'users#setting'
  get '/users/delete_account', to: 'users#delete_account'

  get '/statuses/import',            to: 'statuses#import'
  get '/your/tweets/(:date)',        to: 'statuses#sent_tweets'
  get '/your/home_timeline/(:date)', to: 'statuses#home_timeline'
  get '/public_timeline/(:date)',    to: 'statuses#public_timeline'

  post '/ajax/check_profile_update', to: 'ajax#check_profile_update'
  post '/ajax/check_status_update',  to: 'ajax#check_status_update'
  post '/ajax/check_friend_update',  to: 'ajax#check_friend_update'
  post '/ajax/deactivate_account',   to: 'ajax#deactivate_account'
  post '/ajax/delete_account',       to: 'ajax#delete_account'
  post '/ajax/delete_status',        to: 'ajax#delete_status'
  post '/ajax/update_status',        to: 'ajax#update_status'
  post '/ajax/read_more',            to: 'ajax#read_more'
  get  '/ajax/get_dashbord',         to: 'ajax#get_dashbord'
  post '/ajax/acquire_statuses',     to: 'ajax#acquire_statuses'
  get  '/ajax/switch_term',          to: 'ajax#switch_term'

  get  '*path', to: 'application#render_404'
end
