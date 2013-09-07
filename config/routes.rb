NativeFm::Application.routes.draw do
  get "user/sent", to: "user#sent"
  get "user/received", to: "user#received"
  post "user/create", to: "user#create"

  root :to => "welcome#index"

  resources :users

  resources :transmissions, only: :create
  
end
