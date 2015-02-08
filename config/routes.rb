Myflix::Application.routes.draw do
  
  get '/home', to: 'categories#index'
  get 'ui(/:action)', controller: 'ui'
  
  resources :videos, only: [:show]
  resources :categories, only: [:show]
  
  root to: 'categories#index'
  
end
