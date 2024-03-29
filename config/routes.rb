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
  resources :lobbies, path: :l, only: [:index, :new, :show] do
    resources :messages, only: [:create, :index], shallow: true
    resources :lobby_users, only: [:index, :show, :destroy], shallow: true

    resources :games, only: [:create, :show], shallow: true do
      resources :players, only: [:create], shallow: true do
        resources :cards, only: [:create, :index], controller: 'players/cards'
      end

      resources :rounds, only: [:create, :show], shallow: true do
        resources :cards, only: [:create, :update], controller: 'rounds/cards'
        resource :winner, only: [:create], controller: 'rounds/winners'
      end
    end
  end

  namespace :admin do
    root to: 'dashboard#show', as: :dashboard

    resources :expansions do
      resources :cards, only: [:new, :create, :edit, :update, :destroy], shallow: true
    end

    resources :users
  end
end
