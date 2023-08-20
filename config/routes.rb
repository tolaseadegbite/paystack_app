Rails.application.routes.draw do
  resources :products
  root "products#index"

  post "checkout/create", to: 'checkout#create'
  resources :webhooks, only: [:create]
end
