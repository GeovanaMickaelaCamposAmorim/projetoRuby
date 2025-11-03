class AddContratanteToGastos < ActiveRecord::Migration[8.0]
  def change

    drop_table :gastos if table_exists?(:gastos)


    create_table :gastos do |t|
      t.datetime :gas_data, null: false
      t.string :gas_descricao, null: false
      t.decimal :gas_valor, precision: 10, scale: 2, null: false
      t.references :user, null: false, foreign_key: true # GAS_USUARIO
      t.references :contratante, null: false, foreign_key: true # GAS_ID_CONTRATANTE
      t.datetime :gas_data_cadastro, default: -> { 'CURRENT_TIMESTAMP' }
      
      t.timestamps
    end

    add_index :gastos, :gas_data
  end
end