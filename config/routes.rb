Rails.application.routes.draw do
  #get '/:anything',to: "errors#error_404", :constraints => { :anything => /.*/ }, via: :all
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

  resources :transactions, only: [:new, :create] do
    collection do
      get 'new_customer', to: 'transactions#new_customer'
      post 'create_customer',to: 'transactions#create_customer'
    end
  end
  delete '/transactions' => 'transactions#destroy', as: :transaction

  devise_for :users, controllers: { registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks' }

  resource :favorite, only: [:show]

  resource :cart, only: [:show]

  resources :order_items, only: [:create, :update, :destroy] # , defaults: { format: 'js' } do
  # musts set default values because files are .js not erb #

  resources :addresses, only:[:index,:edit,:new,:destroy] do
    get 'delete'
  end
  #get '/address' => 'addresses#show'
  put '/address/:id' => 'addresses#update', as: :address_update
  post '/address' => 'addresses#create', as: :address_create

  resources :payment_methods

  #get 'checkout/launch' => 'transactions#new_customer'
  #post 'checkout/launch' => 'transactions#create_customer'

  #this line must be always at the end of the routes file to work properly, RoutingError Handling
  #match '*a', :to => 'errors#error_404',via: :all
end
