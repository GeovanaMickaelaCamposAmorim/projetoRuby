class HomeController < ApplicationController
  def index
    # Se estiver autenticado, vai para PDV
    if authenticated?
      redirect_to pdv_path
    else
      redirect_to login_path
    end
  end

  private

  def authenticated?
    # Sua lógica de autenticação aqui
    # Exemplo: session[:user_id].present?
    true 
  end
end