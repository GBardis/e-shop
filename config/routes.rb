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
    devise_for :users, controllers: { registrations: 'registrations' }

    resource :cart, only: [:show]
    resources :order_items, only: [:create, :update, :destroy]

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
