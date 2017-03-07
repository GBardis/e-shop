Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'products#index'
  post '/rate' => 'rater#create', :as => 'rate'
  resources :categories do
    resources :products do
    end
  end

  resources :products do
    resources :images do
    end
  end
  resources :products do
    put :favorite, on: :member
  end

  resources :products do
    resources :comments, only: [:create, :destroy] # , defaults: { format: 'js' } do
  end
  resources :favorite_products, only: [:create, :destroy, :show] # , defaults: { format: 'js' }
  resources :images
  resources :messages
  resources :products
  get '/profile/:id' => 'users#show', as: :profile
  get '/orders/:id' => 'orders#show', as: :orders
  get '/order_details/:id' => 'orders#order_details', as: :order_details
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resource :favorite, only: [:show]
  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy] # , defaults: { format: 'js' } do
  # musts set default values because files are .js not erb #

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
