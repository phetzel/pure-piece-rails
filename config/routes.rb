Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  namespace :api do 
    namespace :v1 do 
      resources :subscriptions
      resources :products
      post :orders, to: 'orders#create'
      post :payment_intents, to: 'payment_intents#create'
      post :checkout, to: 'checkout#create'
    end
  end
end
