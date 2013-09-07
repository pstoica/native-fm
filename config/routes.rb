NativeFm::Application.routes.draw do

  resources :transmissions, only: [:create, :show], :defaults => { :format => 'json' }
  get "user/sent", to: "user#sent", :defaults => { :format => 'json' }
  get "user/received", to: "user#received", :defaults => { :format => 'json' }
  
  root to: 'main#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
end
