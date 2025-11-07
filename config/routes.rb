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

  # ROTAS MANUAIS - mais simples e diretas
  get "configuracoes", to: "configuracoes#index", as: "configuracoes"
  patch "configuracoes", to: "configuracoes#update"
  put "configuracoes", to: "configuracoes#update"

  get "up" => "rails/health#show", as: :rails_health_check
  root "sessions#new"
  get "home", to: "gastos#index"

  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
end
