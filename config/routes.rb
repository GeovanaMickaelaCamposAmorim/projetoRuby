Rails.application.routes.draw do
  root "home#index"

  # Rotas do PDV
  get "pdv", to: "pdv#index"
  post "pdv/buscar_produto", to: "pdv#buscar_produto"
  post "pdv/finalizar_venda", to: "pdv#finalizar_venda"

  # Rotas principais
  resources :gastos, :vendas, :marcas, :tipos, :tamanhos, :taxa_cartoes, :pixes

  resources :produtos do
    collection do
      get :buscar
    end
  end

  resources :clientes, except: [ :show ]
  resources :users, except: [ :show ]
  resources :configuracoes, only: [ :index, :update ]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Autenticação
  get "login", to: "sessions#new"
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
end
