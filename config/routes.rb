Rails.application.routes.draw do
  resources :gastos, :produtos, :vendas, :marcas, 
            :tipos, :tamanhos, :taxa_cartoes, :pixes

resources :clientes, except: [:show]
resources :users, except: [:show]


  # CORREÇÃO: Use resources (plural) se precisa de index
  resources :configuracoes, only: [:index, :update]
  
  # OU se for realmente uma rota singular (sem index):
  # resource :configuracoes, only: [:show, :update]
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Rotas de autenticação
  get "login", to: "sessions#new"
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  
  # Rota raiz - escolha uma que exista!
  root "gastos#index"  # Se gastos#index existe
end