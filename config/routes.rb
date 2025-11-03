Rails.application.routes.draw do

  resources :gastos
  resources :produtos
  resources :vendas
  resources :clientes
  resources :marcas
  resources :tipos
  resources :tamanhos
  resources :taxa_cartoes
  resources :pixes
  
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"


  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  
end