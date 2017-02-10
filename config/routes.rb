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
    resources :comments, only: [:create, :destroy] do
    end
  end
  resources :favorite_products, only: [:create, :destroy, :show] # , defaults: { format: 'js' }
  resources :images
  resources :messages
  resources :products
  # resources :comments
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy] # , defaults: { format: 'js' }
  # musts set default values because files are .js not html #

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
