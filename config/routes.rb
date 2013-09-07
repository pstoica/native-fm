NativeFm::Application.routes.draw do
  get "user/sent", to: "user#sent"
  get "user/received", to: "user#received"
  post "user/create", to: "user#create"

  resources :users

  resources :transmissions, only: :create
  
  root to: 'main#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
end
