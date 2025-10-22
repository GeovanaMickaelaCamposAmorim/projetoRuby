Rails.application.routes.draw do
  get "home/index"
  resource :session
  resources :passwords, param: :token


  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")

  root "home#index"
end
