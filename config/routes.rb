Rails.application.routes.draw do
  resources :ruby_gem_data, only: [:index]
  resources :ruby_apps, only: [:index, :show, :create]
  root to: 'dashboard#index'
end
