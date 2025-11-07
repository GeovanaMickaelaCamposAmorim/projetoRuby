class ApplicationController < ActionController::Base
  before_action :set_current_user_from_session
  before_action :carregar_configuracoes

  helper_method :authenticated?, :current_user

  def authenticated?
    Current.user.present?
  end

  def current_user
    Current.user
  end

  private

  def carregar_configuracoes
    @configuracao_global = Configuracao.first_or_initialize
  end

  def set_current_user_from_session
    # Não tenta carregar sessão para ações públicas
    return if public_action?

    if session_id = cookies.signed[:session_id]
      if user_session = UserSession.find_by(id: session_id)
        Current.user = user_session.user
        Current.session = user_session
      else
        # Sessão inválida - limpa o cookie
        cookies.delete(:session_id)
        redirect_to root_path, alert: "Sessão expirada" unless public_action?
      end
    else
      # Não tem sessão - redireciona para login se não for ação pública
      redirect_to root_path, alert: "Faça login para continuar" unless public_action?
    end
  end

  def public_action?
    # Define quais controllers/ações são públicas (não requerem login)
    controller_name == 'sessions' && action_name.in?(%w[new create])
  end
end