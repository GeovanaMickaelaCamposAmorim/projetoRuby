class ChangeProdutoEstoqueToInteger < ActiveRecord::Migration[7.0]
  def up
    # Converte os campos para integer
    change_column :produtos, :pro_quantidade, :integer
    change_column :produtos, :pro_estoque_minimo, :integer
  end

  def down
    # Reverte para decimal se necessário
    change_column :produtos, :pro_quantidade, :decimal
    change_column :produtos, :pro_estoque_minimo, :decimal
  end
end