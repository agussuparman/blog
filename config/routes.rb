Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :articles do
  	resources :comments, only: [:new, :create]
  end
  resources :categories, except: [:show]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
