class CreateGastos < ActiveRecord::Migration[8.0]
  def change
    create_table :gastos do |t|
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.references :usuario, null: false, foreign_key: { to_table: :users }
      t.date :data, null: false
      t.text :descricao

      t.timestamps
    end
  end
end