Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  namespace :api do 
    namespace :v1 do 
      get 'member_details' => 'members#index'

      resources :subscriptions
      post :unsubscribe, to: 'subscriptions#unsubscribe'

      resources :products
      resources :contacts, only: [:create]
      resources :newsletters, only: [:index, :create]

      post :checkout, to: 'checkout#create'
      resources :stripe
    end
  end
end
