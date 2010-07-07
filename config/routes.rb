ActionController::Routing::Routes.draw do |map|
  map.resource :account
  map.resources :users
  map.resources :password_resets
  map.resources :contacts, :collection => { :search => :get }
  map.resources :contact_groups, :member => { :drop_contact => :post, :add_members => :get, :add_contacts => :post },
    :collection => { :emails => :get }
  map.resources :events, :member => { :drop_contact => :post, :add_attendees => :get, :add_contacts => :post },
    :collection => { :search => :get }
  map.resources :file_attachments, :member => { :download => :get }
  map.resources :event_revisions

  map.connect 'themes/:action', :controller => 'themes'
  map.connect 'themes/:action/:name.:format', :controller => 'themes'
  map.resources :site_settings, :collection => { :update_site_settings => :post, :admin => :get }
  map.resource :user_session

  map.root :controller => "site_settings", :action => "homepage"
end
