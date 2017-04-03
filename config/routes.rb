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

  resources :images
  resources :messages
  resources :products

  get '/profile/:id' => 'users#show', as: :profile

  get '/orders/:id' => 'orders#show', as: :orders
  get '/order_details/:id' => 'orders#order_details', as: :order_details

  resources :transactions, only: [:new, :create]
  delete '/transactions' => 'transactions#destroy', as: :transaction

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resource :favorite, only: [:show]

  resource :cart, only: [:show]

  resources :order_items, only: [:create, :update, :destroy] # , defaults: { format: 'js' } do
  # musts set default values because files are .js not erb #

  resources :addresses do
    get 'delete'
  end
  put '/address/:id' => 'addresses#update', as: :address_update
  post '/address' => 'addresses#create', as: :address_create

  resources :payment_methods

  get 'checkout/launch' => 'transactions#new_customer'
  post 'checkout/launch' => 'transactions#create_customer'
end
