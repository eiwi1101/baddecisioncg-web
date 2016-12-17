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

    resources :games, only: [:create, :show], shallow: true do
      resources :players, only: [:create], shallow: true

      resources :rounds, only: [:create], shallow: true do
        resources :player_cards, only: [:create], shallow: true do
          collection do
            post :winner
          end
        end
      end

      member do
        post :start
      end
    end
  end

  resources :lobby_users, only: [:destroy]

  namespace :admin do
    root to: 'dashboard#show', as: :dashboard

    resources :expansions do
      resources :cards, only: [:new, :create, :edit, :update, :destroy], shallow: true
    end

    resources :users
  end
end
