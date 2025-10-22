class ApplicationController < ActionController::Base
  before_action :set_current_user_from_session
  helper_method :authenticated?, :current_user

  private

  def set_current_user_from_session
    if session_id = cookies.signed[:session_id]
      if user_session = UserSession.find_by(id: session_id)
        Current.user = user_session.user
        Current.session = user_session
      else

        # Sessão inválida - limpa o cookie
        cookies.delete(:session_id)
        Current.user = nil
        Current.session = nil
      end
    end
  end

  def authenticated?
    Current.user.present?
  end

  def current_user
    Current.user
  end
end
