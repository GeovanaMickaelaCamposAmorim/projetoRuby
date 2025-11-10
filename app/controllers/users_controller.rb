class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    # Filtra apenas funcionários (exclui clientes)
    @users = User.where(contratante_id: current_user.contratante_id)
                 .where.not(usu_tipo: ['cliente', 'master'])
                 .order(:usu_nome)
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where("usu_nome ILIKE :search OR usu_email ILIKE :search", search: search_term)
    end
    
    if params[:usu_tipo].present?
      @users = @users.where(usu_tipo: params[:usu_tipo])
    end
  end

  def new
    @user = User.new(usu_tipo: 'vendedor', usu_status: 'ativo')
  end

  def create
    @user = User.new(user_params)
    @user.contratante_id = current_user.contratante_id
    @user.password = '123456' # Senha padrão
    @user.password_confirmation = '123456'

    if @user.save
      redirect_to users_path, notice: 'Funcionário criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'Funcionário atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Funcionário excluído com sucesso!'
  end

  private

  def set_user
    @user = User.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :usu_nome, :usu_email, :usu_telefone, :usu_tipo, :usu_status
    )
  end
end