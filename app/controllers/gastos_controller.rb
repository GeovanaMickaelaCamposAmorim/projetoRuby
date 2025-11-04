class GastosController < ApplicationController
  before_action :set_gasto, only: [:edit, :update, :destroy]


  def index
    @gastos = Gasto.where(contratante_id: current_user.contratante_id)
                   .includes(:user)
                   .ordenados_por_data
    @total_mes = Gasto.total_no_periodo(Date.today.beginning_of_month, Date.today.end_of_month, current_user.contratante_id)
  end

  def new
    @gasto = Gasto.new(gas_data: Time.now)
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