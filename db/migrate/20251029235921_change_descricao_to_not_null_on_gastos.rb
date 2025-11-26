class ChangeDescricaoToNotNullOnGastos < ActiveRecord::Migration[8.0]
  def change
    # Atualiza valores NULL para string vazia
    execute <<~SQL
      UPDATE gastos
      SET descricao = ''
      WHERE descricao IS NULL;
    SQL

    # Impõe NOT NULL na coluna
    change_column_null :gastos, :descricao, false
  end
end
