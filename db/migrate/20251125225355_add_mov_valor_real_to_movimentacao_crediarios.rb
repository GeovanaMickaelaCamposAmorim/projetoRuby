class AddMovValorRealToMovimentacaoCrediarios < ActiveRecord::Migration[8.0]
  def change
    add_column :movimentacao_crediarios, :mov_valor_real, :decimal
  end
end
