Rails.application.routes.draw do
  root to: 'sessions#new'

  # Session Handling
  get :login,  to: 'sessions#new'
  get :logout, to: 'sessions#destroy'
  post :login, to: 'sessions#create'

  # Registration Handling
  get :register, to: 'users#new'
  post :register, to: 'users#create'

  # Other Resources
  resources :game_lobbies, path: :play, only: [:index, :new, :show]
  resources :game_lobby_users, only: [:destroy]
end
