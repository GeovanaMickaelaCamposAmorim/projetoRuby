class CreateMovimentacaoCrediarios < ActiveRecord::Migration[8.0]
  def change
    create_table :movimentacao_crediarios do |t|
      t.references :ficha_crediario, null: false, foreign_key: true
      t.string :mov_tipo
      t.decimal :mov_valor, precision: 10, scale: 2, default: 0
      t.text :mov_observacao

      t.timestamps
    end
  end
end
