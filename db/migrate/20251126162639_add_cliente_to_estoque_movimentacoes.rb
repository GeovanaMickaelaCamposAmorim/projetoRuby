class AddClienteToEstoqueMovimentacoes < ActiveRecord::Migration[8.0]
  def change
    add_reference :estoque_movimentacoes, :cliente, null: false, foreign_key: true
  end
end
