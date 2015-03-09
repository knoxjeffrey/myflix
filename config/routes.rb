Myflix::Application.routes.draw do
  
  root to: 'pages#home'
  
  get '/register', to: 'users#new'
  
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  
  get '/home', to: 'categories#index'
  
  get '/my_queue', to: 'queue_items#index'
  
  get '/people', to: 'friendships#index'
  
  get 'ui(/:action)', controller: 'ui'
  
  resources :users, only: [:create, :show]
  
  resources :videos, only: [:show] do
    get :search, on: :collection
    resources :reviews, only: [:create]
  end
  
  resources :categories, only: [:show]
  
  resources :queue_items, only: [:create, :destroy] do
    post :sort, on: :collection
  end
  
  resources :friendships, only: [:destroy]
  
end
