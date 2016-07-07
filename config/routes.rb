Rails.application.routes.draw do
  root 'main#index'
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
end
