Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    resources :products
    resources :categories do
        resources :products do
        end
    end
    resources :images
    resources :messages
    root 'products#index'
    get 'products/show' => 'products#show'

    devise_for :users, controllers: { registrations: 'registrations' }
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
