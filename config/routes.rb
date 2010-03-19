ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :contacts
  map.resource :user_session
  map.root :controller => "user_sessions", :action => "show"
end
