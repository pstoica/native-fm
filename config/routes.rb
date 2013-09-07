NativeFm::Application.routes.draw do

  resources :transmissions, only: [:create, :show], defaults: { format: 'json' }
  
  put "user", to: "user#update", defaults: { format: 'json' }

  get "songs/sent", to: "songs#sent", defaults: { format: 'json' }
  get "songs/received", to: "songs#received", defaults: { format: 'json' }
  
  root to: 'main#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
end
