Rails.application.routes.draw do
  # Mude a rota raiz para home#index (pública)
  root "home#index"

  resources :gastos, :produtos, :vendas, :marcas, 
            :tipos, :tamanhos, :taxa_cartoes, :pixes

  resources :clientes, except: [:show]
  resources :users, except: [:show]
  resources :configuracoes, only: [:index, :update]
  
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Rotas de autenticação
  get "login", to: "sessions#new"
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
end