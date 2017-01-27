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
    resources :comments
  end

  resources :images
  resources :messages
  resources :products
  resources :comments
  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resource :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy], defaults: { format: 'js' } do
    collection do
      delete :destroy_multiple
    end
  end # musts set default values because files are .js not erb #

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
