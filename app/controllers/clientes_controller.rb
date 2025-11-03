class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]

  def index
    @clientes = Cliente.where(contratante_id: current_user.contratante_id).includes(:user)
  end

  def new
    @cliente = Cliente.new
  end

  def create
    user = User.new(
      usu_nome: cliente_params[:user_attributes][:usu_nome],
      usu_email: cliente_params[:user_attributes][:usu_email],
      usu_telefone: cliente_params[:cli_telefone1],
      usu_tipo: 'cliente',
      password: '123456',
      password_confirmation: '123456',
      contratante_id: current_user.contratante_id
    )

    if user.save
      @cliente = Cliente.new(cliente_params.except(:user_attributes))
      @cliente.user = user
      @cliente.contratante_id = current_user.contratante_id

      if @cliente.save
        redirect_to clientes_path, notice: 'Cliente criado com sucesso!'
      else
        user.destroy
        render :new, status: :unprocessable_entity
      end
    else
      @cliente = Cliente.new(cliente_params)
      @cliente.errors.merge!(user.errors)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @cliente.update(cliente_params)
      redirect_to clientes_path, notice: 'Cliente atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cliente.destroy
    redirect_to clientes_path, notice: 'Cliente excluído com sucesso!'
  end

  private

  def set_cliente
    @cliente = Cliente.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def cliente_params
    params.require(:cliente).permit(:cli_cpf, :cli_data_nasc, :cli_estado_civil,
                                   :cli_endereco, :cli_telefone1, :cli_telefone2,
                                   :cli_email, :cli_observacao,
                                   user_attributes: [:usu_nome, :usu_email])
  end
end