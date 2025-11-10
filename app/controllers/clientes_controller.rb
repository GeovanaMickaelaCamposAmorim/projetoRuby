class ClientesController < ApplicationController
  before_action :set_cliente, only: [:edit, :update, :destroy]

def index
  @clientes = Cliente.where(contratante_id: current_user.contratante_id)
  
  if params[:search].present?
    search_term = "%#{params[:search]}%"
    @clientes = @clientes.where(
      "cli_nome ILIKE :search OR cli_email ILIKE :search OR cli_telefone1 ILIKE :search", 
      search: search_term
    )
  end
    
 if params[:status].present?
    @clientes = @clientes.where(status: params[:status])
  end
  
  @clientes = @clientes.order('cli_nome ASC')
end

  def new
  @cliente = Cliente.new(status: 'ativo') 
  end

  def create
    @cliente = Cliente.new(cliente_params)
    @cliente.contratante_id = current_user.contratante_id

    if @cliente.save
      redirect_to clientes_path, notice: 'Cliente criado com sucesso!'
    else
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
    params.require(:cliente).permit(
      :cli_nome, :cli_cpf, :cli_data_nasc, :cli_estado_civil, 
      :cli_endereco, :cli_telefone1, :cli_telefone2, :cli_email, :cli_observacao, :status
    )
  end
end