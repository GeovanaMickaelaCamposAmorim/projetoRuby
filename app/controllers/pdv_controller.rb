class PdvController < ApplicationController
  before_action :carregar_dados

  def index
    @clientes = Cliente.where(
      contratante_id: current_user.contratante_id,
      status: "ativo"
    ).order(:cli_nome)
  end

  def buscar_produto
    termo = params[:termo].to_s.strip

    produtos = Produto.where(contratante_id: current_user.contratante_id)
                     .where("pro_nome ILIKE :termo OR pro_codigo ILIKE :termo", termo: "%#{termo}%")
                     .limit(10)

    if produtos.any?
      render json: produtos.map { |p|
        {
          id: p.id,
          nome: p.pro_nome,
          codigo: p.pro_codigo,
          valor_venda: p.pro_valor_venda.to_f
        }
      }
    else
      render json: []
    end
  end

  def finalizar_venda
    ActiveRecord::Base.transaction do
      # Calcular totais
      subtotal = params[:itens].sum { |item| item[:quantidade].to_i * item[:valor].to_f }
      desconto = params[:desconto].to_f
      total = [ subtotal - desconto, 0 ].max

      # Criar venda
      @venda = Venda.new(
        ven_data: Time.current,
        user_id: current_user.id,
        contratante_id: current_user.contratante_id,
        cliente_id: params[:cliente_id].presence,
        ven_forma_pagamento: params[:forma_pagamento],
        ven_valor_total: subtotal,
        ven_valor_final: total,
        ven_desconto: desconto
      )

      if @venda.save
        # Criar itens da venda
        params[:itens].each do |item|
          VendaItem.create!(
            venda_id: @venda.id,
            produto_id: item[:id],
            vei_quantidade: item[:quantidade],
            vei_preco_unitario: item[:valor]
          )
        end

        render json: {
          success: true,
          venda_id: @venda.id,
          numero_venda: @venda.id,
          data: @venda.ven_data.strftime("%d/%m/%Y %H:%M"),
          total: @venda.ven_valor_final.to_f,
          cliente: @venda.cliente&.cli_nome || "Cliente Avulso",
          forma_pagamento: @venda.ven_forma_pagamento.humanize
        }
      else
        render json: { success: false, errors: @venda.errors.full_messages }
      end
    end
  rescue => e
    render json: { success: false, error: e.message }
  end

  private

  def carregar_dados
    @produtos = Produto.where(contratante_id: current_user.contratante_id).order(:pro_nome)
    @clientes = Cliente.where(contratante_id: current_user.contratante_id, status: "ativo").order(:cli_nome)
  end
end
