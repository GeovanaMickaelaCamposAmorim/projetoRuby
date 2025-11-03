class ChangeDescricaoToNotNullOnGastos < ActiveRecord::Migration[8.0]
  def change
    # Primeiro, atualize quaisquer registros com descricao nula para uma string vazia
    Gasto.where(descricao: nil).update_all(descricao: "")
    
    # Depois altere a coluna para NOT NULL
    change_column_null :gastos, :descricao, false
  end
end