Ditto::Application.routes.draw do
  resources :expected_responses
  resources :input_requests
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'dashboard#overview'
  
  resources :routes
  resources :matchers

  get 'route/execute_route' => 'routes#execute_route'

  ActiveAdmin.routes(self)
end
