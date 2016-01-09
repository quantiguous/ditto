Ditto::Application.routes.draw do
  
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'dashboard#overview'
  
  resources :routes
  resources :matchers
  resources :request_logs
  resources :xml_validators

  match '/route/execute_route/:uri', to: 'routes#execute_route', via: :all
  
  match "*path", to: "routes#execute_route", via: :all

  ActiveAdmin.routes(self)
end
