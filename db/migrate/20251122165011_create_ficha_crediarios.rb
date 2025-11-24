class CreateFichaCrediarios < ActiveRecord::Migration[8.0]
  def change
    create_table :ficha_crediarios do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :contratante, null: false, foreign_key: true
      t.decimal :fic_valor_total, precision: 10, scale: 2, default: 0
      t.string :fic_status, default: "pendente"
      
      t.timestamps
    end
  end
end
