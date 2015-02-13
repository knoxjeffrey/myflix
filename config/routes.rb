Myflix::Application.routes.draw do
  
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  get '/home', to: 'categories#index'
  get 'ui(/:action)', controller: 'ui'
  
  resources :users, only: [:create]
  
  resources :videos, only: [:show] do
    get :search, on: :collection
  end
  
  resources :categories, only: [:show]
  
  root to: 'pages#home'
  
end
