Rails.application.routes.draw do
  root 'main#index'

  resources :leaderboards, only: [:index]

  resources :games, only: [:index, :show, :create] do
    resources :positions, only: [:update]
  end

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
end
