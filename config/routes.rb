NativeFm::Application.routes.draw do

  resources :transmissions, only: [:create, :show], defaults: { format: 'json' }
  
  put "user", to: "user#update", defaults: { format: 'json' }
  get "user", to: "user#show", defaults: { format: 'json' }

  resources :preferences, defaults: { format: 'json' }

  get "songs/sent", to: "songs#sent", defaults: { format: 'json' }
  get "songs/received", to: "songs#received", defaults: { format: 'json' }
  get "songs/data", to: "songs#data", defaults: { format: 'json' }
  get "songs/search", to: "songs#search", defaults: { format: 'json' }
  
  root to: 'main#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
end
