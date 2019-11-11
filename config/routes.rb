Rails.application.routes.draw do
 
  root 'home#index'
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # devise_for :users, controllers: {registrations: 'users/registrations',omniauth_callbacks: 'users/omniauth_callbacks'}
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    confirmations: 'users/confirmations',
  }
end

