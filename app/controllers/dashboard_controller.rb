class DashboardController < ApplicationController

def index
    # Define o período de análise para os gráficos (6 meses)
    @data_inicio = 6.months.ago.beginning_of_month
    @data_fim = Date.current.end_of_month
    
    # 1. Dados para os Cards (Estatísticas de Vendas Atuais)
    calcular_estatisticas_vendas 
    
    # 2. Dados para Vendas e Gastos (Groupdate em ação)
   @vendas_por_mes = Venda.where(contratante_id: current_user.contratante_id)
                         .where(ven_data: @data_inicio..@data_fim)
                         .group_by_month(:ven_data, format: "%Y-%m") # <-- MUDANÇA AQUI
                         .sum(:ven_valor_final)

  @gastos_por_mes = Gasto.where(contratante_id: current_user.contratante_id)
                         .where(gas_data: @data_inicio..@data_fim)
                         .group_by_month(:gas_data, format: "%Y-%m") # <-- MUDANÇA AQUI
                         .sum(:gas_valor)
    
    @dados_vendas_gastos = [
    { name: "Vendas (R$)", data: @vendas_por_mes },
    { name: "Gastos (R$)", data: @gastos_por_mes }
  ]
    
    # 3. Lucro Mensal (Cálculo no Ruby)
    lucro_hash = @vendas_por_mes.merge(@gastos_por_mes) { |key, vendas, gastos| (vendas.to_f || 0) - (gastos.to_f || 0) }
    @lucro_por_mes = lucro_hash.sort_by { |key, value| key }.to_h
    
    # 4. Distribuição de Vendas por Forma de Pagamento
    @vendas_por_forma = Venda.where(contratante_id: current_user.contratante_id)
                             .group(:ven_forma_pagamento)
                             .sum(:ven_valor_final)
                             
    # 5. Dados de Estoque
    produtos_base = Produto.where(contratante_id: current_user.contratante_id)
                           .where(pro_status: 'ativo') # Apenas produtos ativos
    
    @produtos_ativos = produtos_base.count
    @produtos_esgotados = produtos_base.where("pro_quantidade <= 0").count
    @produtos_baixo_estoque = produtos_base.where("pro_quantidade > 0 AND pro_quantidade <= pro_estoque_minimo").count

    # Dados para o Gráfico de Estoque
    @dados_estoque = [
      ["Disponível", @produtos_ativos - @produtos_esgotados - @produtos_baixo_estoque],
      ["Baixo Estoque", @produtos_baixo_estoque],
      ["Esgotado", @produtos_esgotados]
    ].reject { |name, count| count <= 0 }
    
    # 6. Dados de Crediário (Se precisar de um gráfico de status)
    @crediario_status = FichaCrediario.where(contratante_id: current_user.contratante_id)
                                      .group(:fic_status)
                                      .count
  end
  
  private

  # Método adaptado do VendasController para os cards do dashboard
  def calcular_estatisticas_vendas
    hoje = Date.current
    vendas_periodo = Venda.where(contratante_id: current_user.contratante_id)
    
    # Vendas do Dia
    @vendas_hoje = vendas_periodo.where(ven_data: hoje.beginning_of_day..hoje.end_of_day)
                               .sum(:ven_valor_final)
                               
    # Vendas do Mês
    vendas_mes_scope = vendas_periodo.where(ven_data: hoje.beginning_of_month..hoje.end_of_month)
    @vendas_mes = vendas_mes_scope.sum(:ven_valor_final)
    @total_vendas_mes = vendas_mes_scope.count

    # Ticket Médio do Mês
    @ticket_medio = @total_vendas_mes > 0 ? @vendas_mes / @total_vendas_mes : 0
  end
  
end