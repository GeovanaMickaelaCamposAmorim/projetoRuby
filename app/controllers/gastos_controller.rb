class GastosController < ApplicationController
  before_action :set_gasto, only: [:edit, :update, :destroy]


def index
    @gastos = Gasto.where(contratante_id: current_user.contratante_id)
                   .includes(:user)
                   .ordenados_por_data
    
    # Filtro por descrição
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @gastos = @gastos.where("gas_descricao ILIKE :search", search: search_term)
    end
    
    # Filtro por mês (independente do ano)
    if params[:mes].present?
      @gastos = @gastos.where("EXTRACT(MONTH FROM gas_data) = ?", params[:mes])
    end
    
    # Filtro por ano (independente do mês)
    if params[:ano].present?
      @gastos = @gastos.where("EXTRACT(YEAR FROM gas_data) = ?", params[:ano])
    end
    
    # Filtro por usuário
    if params[:usuario_id].present? && params[:usuario_id] != 'todos'
      @gastos = @gastos.where(user_id: params[:usuario_id])
    end
    
    # Usuários disponíveis para filtro
      @usuarios = User.where(contratante_id: current_user.contratante_id).order(:usu_nome)
    
    
    @total_mes = Gasto.total_no_periodo(Date.today.beginning_of_month, Date.today.end_of_month, current_user.contratante_id)
  end


 def new
  @gasto = Gasto.new(gas_data: Date.current)  # Mude para Date.current
 end

  def create
    @gasto = Gasto.new(gasto_params)
    @gasto.user = current_user
    @gasto.contratante_id = current_user.contratante_id

    if @gasto.save
      redirect_to gastos_path, notice: 'Gasto criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gasto.update(gasto_params)
      redirect_to gastos_path, notice: 'Gasto atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gasto.destroy
    redirect_to gastos_path, notice: 'Gasto excluído com sucesso!'
  end

  def relatorio
    @data_inicio = params[:data_inicio] || Date.today.beginning_of_month
    @data_fim = params[:data_fim] || Date.today.end_of_month
    
    @gastos = Gasto.where(contratante_id: current_user.contratante_id)
                   .por_periodo(@data_inicio, @data_fim)
                   .ordenados_por_data
    @total_periodo = @gastos.sum(:gas_valor)
  end

  private

  def set_gasto
    @gasto = Gasto.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def gasto_params
    params.require(:gasto).permit(:gas_data, :gas_descricao, :gas_valor)
  end
end