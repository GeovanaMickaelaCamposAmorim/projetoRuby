class VendasController < ApplicationController
  before_action :set_venda, only: [:show, :edit, :update, :destroy]

  def index
    @vendas = Venda.where(contratante_id: current_user.contratante_id)
                   .includes(:user, :cliente)
                   .order(ven_data: :desc)
  end

  def new
    @venda = Venda.new(
      ven_data: Time.now,
      user: current_user,
      ven_valor_total: 0,
      ven_valor_final: 0
    )
    carregar_dependencias
  end

  def create
    @venda = Venda.new(venda_params)
    @venda.user = current_user
    @venda.contratante_id = current_user.contratante_id

    if @venda.save
      redirect_to venda_path(@venda), notice: 'Venda registrada com sucesso!'
    else
      carregar_dependencias
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @venda_itens = @venda.venda_itens.includes(:produto)
  end

  def edit
    carregar_dependencias
  end

  def update
    if @venda.update(venda_params)
      redirect_to venda_path(@venda), notice: 'Venda atualizada com sucesso!'
    else
      carregar_dependencias
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @venda.destroy
    redirect_to vendas_path, notice: 'Venda excluída com sucesso!'
  end

  private

  def set_venda
    @venda = Venda.where(contratante_id: current_user.contratante_id).find(params[:id])
  end

  def venda_params
    params.require(:venda).permit(:ven_data, :cliente_id, :ven_valor_total, 
                                 :ven_valor_final, :ven_valor_real, :ven_desconto,
                                 :ven_forma_pagamento)
  end

  def carregar_dependencias
    @clientes = Cliente.where(contratante_id: current_user.contratante_id).includes(:user)
    @produtos = Produto.where(contratante_id: current_user.contratante_id).ativos
  end
end