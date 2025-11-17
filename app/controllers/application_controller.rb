class ApplicationController < ActionController::Base
  before_action :set_current_user_from_session
  before_action :carregar_configuracoes
  before_action :require_authentication, unless: :public_action?  # ← ADICIONE ESTA LINHA

  helper_method :authenticated?, :current_user

  def authenticated?
    Current.user.present?
  end

  def current_user
    Current.user
  end

  private

  def current_contratante
    # Se já tivermos carregado, retorna
    return @current_contratante if defined?(@current_contratante)
    
    # Lógica para obter o contratante atual:
    # 1. Pega o primeiro contratante (para desenvolvimento)
    # 2. Ou baseado no usuário logado
    # 3. Ou baseado na sessão
    @current_contratante = Contratante.first
  end
  helper_method :current_contratante

  def authenticated?
    # Sua lógica de autenticação
    current_user.present?
  end
  helper_method :authenticated?

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
        Current.user = nil
      end
    else
      # Não tem sessão - apenas define como nil
      Current.user = nil
    end
  end

  
  def require_authentication
  unless authenticated?
    redirect_to login_path, alert: "Faça login para continuar"  
    return false
  end
end

  def public_action?
    # Define quais controllers/ações são públicas (não requerem login)
    (controller_name == 'home' && action_name == 'index') ||  # ← AGORA home#index É PÚBLICA
    (controller_name == 'sessions' && action_name.in?(%w[new create])) ||
    (controller_name == 'passwords' && action_name.in?(%w[new create edit update]))
  end
end