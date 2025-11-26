class ApplicationController < ActionController::Base
  before_action :set_current_user_from_session
  before_action :carregar_configuracoes
  before_action :require_authentication, unless: :public_action?

  helper_method :authenticated?, :current_user

  def authenticated?
    Current.user.present?
  end

  def current_user
    Current.user
  end

  private

  def current_contratante
    # Remove o cache para sempre buscar dados atualizados
    @current_contratante = nil
    Contratante.first
  end
  helper_method :current_contratante

  def carregar_configuracoes
    @configuracao_global = Configuracao.first_or_initialize
  end

  def set_current_user_from_session
    return if public_action?

    if session_id = cookies.signed[:session_id]
      if user_session = UserSession.find_by(id: session_id)
        Current.user = user_session.user
        Current.session = user_session
      else
        cookies.delete(:session_id)
        Current.user = nil
      end
    else
      Current.user = nil
    end
  end

  def require_authentication
    unless authenticated?
      redirect_to new_session_path, alert: "Você precisa estar logado para fazer isso."
    end
  end

  def public_action?
    (controller_name == "home" && action_name == "index") ||
    (controller_name == "sessions" && action_name.in?(%w[new create])) ||
    (controller_name == "passwords" && action_name.in?(%w[new create edit update]))
  end
end
