class SessionsController < ApplicationController
  skip_before_action :set_current_user_from_session, only: [:new, :create]

  def new
    redirect_to gastos_path if authenticated?
  end

def create
   user = User.find_by(usu_email: params[:usu_email])
  puts ">>> USER FOUND? #{user.present?}"
  puts params.inspect


  if user&.authenticate(params[:password])
    # Cria a sessão do usuário
    session = user.user_sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    )

    # Configura o Current e cookies
    Current.user = user
    Current.session = session
    cookies.signed.permanent[:session_id] = {
      value: session.id,
      httponly: true,
      same_site: :lax
    }

    # Redireciona para a página inicial
     
   redirect_to pdv_path
  else
    redirect_to new_session_path, alert: "E-mail ou senha incorretos."
  end
  
end

  def destroy
    Current.session&.destroy
    cookies.delete(:session_id)
    Current.user = nil
    Current.session = nil
    
    redirect_to root_path, notice: "Logged out successfully!"
  end
end