NativeFm::Application.routes.draw do
  root to: 'main#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
end
