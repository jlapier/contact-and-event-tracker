ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :contacts
  map.resources :contact_groups, :member => { :drop_contact => :post, :add_members => :get, :add_contacts => :post }
  map.resource :user_session
  map.root :controller => "user_sessions", :action => "show"
end
