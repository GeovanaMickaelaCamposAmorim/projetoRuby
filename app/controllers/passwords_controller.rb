class PasswordsController < ApplicationController
  # REMOVA ou COMENTE esta linha:
  # allow_unauthenticated_access

  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      # Se você tiver o PasswordsMailer configurado
      # PasswordsMailer.reset(user).deliver_later

      # Por enquanto, apenas log para teste
      Rails.logger.info "Password reset requested for: #{params[:email_address]}"
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    def set_user_by_token
      # Se você não tem password_reset_token implementado, comente esta linha:
      # @user = User.find_by_password_reset_token!(params[:token])

      # Solução temporária - redireciona para evitar erro
      redirect_to new_password_path, alert: "Password reset functionality not yet implemented."
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
