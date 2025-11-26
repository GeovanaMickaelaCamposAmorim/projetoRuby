class CreateEstoqueMovimentacaos < ActiveRecord::Migration[8.0]
  def change
    create_table :estoque_movimentacaos do |t|
      t.date :emv_data
      t.string :emv_tipo
      t.integer :emv_quantidade
      t.decimal :emv_valor_total
      t.references :produto, null: false, foreign_key: true

      t.timestamps
    end
  end
end
