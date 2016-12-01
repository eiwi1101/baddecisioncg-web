Rails.application.routes.draw do
  root to: 'sessions#new'

  get :login,  to: 'sessions#new'
  get :logout, to: 'sessions#destroy'
  post :login, to: 'sessions#create'

  resources :game_lobbies, path: :play, only: [:index, :new, :show]
  resources :game_lobby_users, only: [:show]

  if Rails.env.development?
    get :styles, to: 'styles#index'
  end
end
