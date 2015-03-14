Myflix::Application.routes.draw do
  
  root to: 'pages#home'
  
  get '/register', to: 'users#new'
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
  
  get '/expired_token', to: 'password_resets#expired_token'
  resources :password_resets, only: [:show, :create]
  
  resources :videos, only: [:show] do
    get :search, on: :collection
    resources :reviews, only: [:create]
  end
  
  get 'ui(/:action)', controller: 'ui'

end
