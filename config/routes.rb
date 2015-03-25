require 'sidekiq/web'

Myflix::Application.routes.draw do
  
  root to: 'pages#home'
  get '/expired_token', to: 'pages#expired_token'
  
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_invitation_with_token', as: 'register_with_token'
  resources :users, only: [:create, :show]
  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  get '/home', to: 'categories#index'
  resources :categories, only: [:show]
  
  get '/my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy] do
    post :sort, on: :collection
  end
  
  get '/people', to: 'friendships#index'
  resources :friendships, only: [:create, :destroy]
  
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  resources :forgot_passwords, only: [:create]
  
  resources :password_resets, only: [:show, :create]
  
  resources :videos, only: [:show] do
    get :search, on: :collection
    resources :reviews, only: [:create]
  end
  
  namespace :admin do
    get '/add_video', to: 'videos#new'
    resources :videos, only: [:create]
  end
  
  get '/invite_friend', to: 'invitations#new'
  resources :invitations, only: [:create]
  
  get 'ui(/:action)', controller: 'ui'
  
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

end
