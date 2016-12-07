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
  resources :lobbies, path: :play, only: [:index, :new, :show] do
    resources :messages, only: [:create]
  end

  resources :lobby_users, only: [:destroy]

  namespace :admin do
    root to: 'dashboard#show', as: :dashboard
  end
end
