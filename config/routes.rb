Rails.application.routes.draw do

  devise_for :users

  authenticated :user do
    root 'home#index', as: 'authenticated_root'
  end
  devise_scope :user do
    root 'devise/sessions#new'
  end
  
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  

end
