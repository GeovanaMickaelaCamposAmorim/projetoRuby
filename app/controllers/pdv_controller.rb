class PdvController < ApplicationController
  before_action :carregar_dados

  def index
    @venda = Venda.new(
      ven_data: Date.current,
      user_id: current_user.id,
      contratante_id: current_user.contratante_id,
      ven_valor_total: 0,
      ven_valor_final: 0,
      ven_desconto: 0
    )
  end

  def buscar_produto
    termo = params[:termo].to_s.strip

    produto = Produto.where(contratante_id: current_user.contratante_id)
                    .where("nome ILIKE :termo OR codigo ILIKE :termo", termo: "%#{termo}%")
                    .first

    if produto
      render json: {
        success: true,
        produto: {
          id: produto.id,
          nome: produto.nome,
          codigo: produto.codigo,
          preco: produto.preco,
          estoque: produto.estoque
        }
      }
    else
      render json: { success: false, error: "Produto não encontrado" }
    end
  end

  def finalizar_venda
    ActiveRecord::Base.transaction do
      subtotal = params[:itens].sum { |item| item[:quantidade].to_i * item[:preco_unitario].to_f }
      desconto = params[:venda][:ven_desconto].to_f
      total = subtotal - desconto

      @venda = Venda.new(
        ven_data: Date.current,
        user_id: current_user.id,
        contratante_id: current_user.contratante_id,
        cliente_id: params[:venda][:cliente_id].presence,
        ven_forma_pagamento: params[:venda][:ven_forma_pagamento],
        ven_valor_total: subtotal,
        ven_valor_final: total,
        ven_desconto: desconto
      )

      if @venda.save
        # Criar itens da venda
        params[:itens].each do |item|
          VendaItem.create!(
            venda_id: @venda.id,
            produto_id: item[:produto_id],
            vei_quantidade: item[:quantidade],
            vei_preco_unitario: item[:preco_unitario]
          )
        end

        render json: { success: true, venda_id: @venda.id }
      else
        render json: { success: false, errors: @venda.errors.full_messages }
      end
    end
  rescue => e
    render json: { success: false, error: e.message }
  end

  private

  def carregar_dados
    @produtos = Produto.where(contratante_id: current_user.contratante_id).order(:nome)
    @clientes = Cliente.where(contratante_id: current_user.contratante_id).order(:cli_nome)
  end
end
