Rails.application.routes.draw do
  resources :movimentacao_crediarios
  resources :ficha_crediarios
  # Rota root vai para o PDV
  root "pdv#index"

 
  get "etiquetas/teste", to: "tag_templates#teste", defaults: { format: :pdf }
  post "etiquetas/imprimir_layout", to: "tag_templates#imprimir_layout"

  # Rotas para geração de etiquetas
  get "gerar_etiqueta", to: "tag_templates#new", as: :gerar_etiqueta
  post "gerar_etiqueta", to: "tag_templates#create"

  get "etiquetas/baixar_pdf", to: "tag_templates#baixar_pdf", as: :baixar_pdf_etiquetas
  get "etiquetas/imprimir", to: "tag_templates#imprimir", as: :imprimir_etiquetas, defaults: { format: :pdf }

  # Rotas do PDV
  get "pdv", to: "pdv#index"
  get "pdv/buscar_produto", to: "pdv#buscar_produto"
  post "pdv/finalizar_venda", to: "pdv#finalizar_venda"

get '/dashboard', to: 'dashboard#vendas', as: 'dashboard'

  # Rotas principais

  resources :gastos, :marcas, :tipos, :tamanhos, :taxa_cartoes, :pixes

  resources :estoque_movimentacoes

  resources :users
  resources :clientes

  resources :gastos do
    collection do
      get "new", defaults: { format: :html }
      get "modal", to: "gastos#new"
    end
  end

  resources :ficha_crediarios do
  resources :movimentacao_crediarios, except: [ :show ]
  end



  # Vendas SEM show, apenas com details
  resources :vendas, except: [ :show ] do
    get "detalhes", on: :member
  end


  # Produtos SEM show
  resources :produtos, except: [ :show ]
  get "/produtos/search", to: "produtos#search"

  # Configurações
  get "configuracoes", to: "configuracoes#index", as: "configuracoes"
  patch "configuracoes", to: "configuracoes#update"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Autenticação
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token, only: [ :new, :create, :edit, :update ]
end
