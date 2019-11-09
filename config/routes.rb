Rails.application.routes.draw do

  # get 'sessions/create'
  # get 'sessions/destroy'
  root 'home#index'
  # devise_for :users

  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      confirmations: 'users/confirmations',
  }
  
end
