Myflix::Application.routes.draw do
  
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  get 'ui(/:action)', controller: 'ui'
  
  resources :users, only: [:create]
  
  resources :videos, only: [:show] do
    get :search, on: :collection
  end
  
  resources :categories, only: [:index, :show]
  
  root to: 'pages#home'
  
end
