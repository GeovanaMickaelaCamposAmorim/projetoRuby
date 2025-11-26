class CreateEstoqueMovimentacoes < ActiveRecord::Migration[7.0]
  def change
    create_table :estoque_movimentacoes do |t|
      t.references :produto, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :cliente, foreign_key: true
      t.integer :emv_tipo, null: false
      t.integer :quantidade, null: false
      t.decimal :valor_unitario, precision: 12, scale: 2
      t.decimal :valor_total, precision: 12, scale: 2
      t.datetime :emv_data

      t.timestamps
    end
  end
end
