class VendasController < ApplicationController
  before_action :set_venda, only: [ :edit, :update, :destroy ]

  def index
    @vendas = Venda.where(contratante_id: current_user.contratante_id)
                   .includes(:user, :cliente)
                   .order(ven_data: :desc)

    calcular_estatisticas
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
      redirect_to vendas_path, notice: "Venda registrada com sucesso!"
    else
      carregar_dependencias
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @venda.update(venda_params)
      redirect_to vendas_path, notice: "Venda atualizada com sucesso!"
    else
      carregar_dependencias
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    carregar_dependencias
  end

  def destroy
    @venda.destroy
    redirect_to vendas_path, notice: "Venda excluída com sucesso!"
  end

  def detalhes
    venda = Venda.where(contratante_id: current_user.contratante_id)
                 .includes(:user, :cliente, venda_items: :produto)
                 .find(params[:id])

    render json: {
      id: venda.id,
      ven_data: venda.ven_data,
      ven_valor_total: venda.ven_valor_total,
      ven_desconto: venda.ven_desconto,
      ven_valor_final: venda.ven_valor_final,
      ven_forma_pagamento: venda.ven_forma_pagamento,
      cliente: {
        cli_nome: venda.cliente&.cli_nome
      },
      user: {
        usu_nome: venda.user&.usu_nome
      },
      itens: venda.venda_items.map do |item|
        {
          produto: {
            pro_nome: item.produto&.pro_nome
          },
          quantidade: item.vei_quantidade,
          preco_unitario: item.vei_preco_unitario,
          subtotal: item.vei_subtotal
        }
      end
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Venda não encontrada" }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
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

  def calcular_estatisticas
    hoje = Date.current
    vendas_scope = Venda.where(contratante_id: current_user.contratante_id)

    @vendas_hoje = vendas_scope.where(ven_data: hoje.beginning_of_day..hoje.end_of_day)
                              .sum(:ven_valor_final)
    @vendas_mes = vendas_scope.where(ven_data: hoje.beginning_of_month..hoje.end_of_month)
                             .sum(:ven_valor_final)
    @total_vendas = vendas_scope.count
    @ticket_medio = @total_vendas > 0 ? @vendas_mes / @total_vendas : 0
  end
end
