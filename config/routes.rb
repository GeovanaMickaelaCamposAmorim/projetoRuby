Rails.application.routes.draw do
  root "home#index"

  # Rotas do PDV
  get "pdv", to: "pdv#index"
  get 'pdv/buscar_produto', to: 'pdv#buscar_produto'
  post "pdv/finalizar_venda", to: "pdv#finalizar_venda"

  # Rotas principais
  resources :gastos, :marcas, :tipos, :tamanhos, :taxa_cartoes, :pixes

  # Vendas SEM show, apenas com details
  resources :vendas, except: [:show] do
    get 'details', on: :member
  end
  
  # Produtos SEM show
  resources :produtos, except: [:show]
  get '/produtos/search', to: 'produtos#search'

  resources :clientes, except: [:show]
  resources :users, except: [:show]
  resources :configuracoes, only: [:index, :update]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Autenticação
  get "login", to: "sessions#new"
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
end