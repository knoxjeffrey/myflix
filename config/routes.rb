Myflix::Application.routes.draw do
  
  get '/home', to: 'categories#index'
  get 'ui(/:action)', controller: 'ui'
  
  resources :videos, only: [:show] do
    get :search, on: :collection
  end
  
  resources :categories, only: [:show]
  
  root to: 'categories#index'
  
end
