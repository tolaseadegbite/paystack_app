Rails.application.routes.draw do
  devise_for :users
  
  resources :products
  root "products#index"

  post "checkout/create", to: 'checkout#create'
  
  resources :webhooks, only: [:create]

  post 'products/add_to_cart/:id', to: "products#add_to_cart", as: "add_to_cart"

  delete 'products/remove_from_cart/:id', to: "products#remove_from_cart", as: "remove_from_cart"

  get 'cart', to: "application#load_cart", as: "cart"

  get '/success', to: "checkout#success", as: "checkout_success"
  get '/failure', to: "checkout#failure", as: "checkout_failure"
end
