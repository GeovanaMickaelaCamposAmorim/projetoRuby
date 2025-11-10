class AddContratanteIdToMarcas < ActiveRecord::Migration[8.0]
  def change
    add_column :marcas, :contratante_id, :bigint
    add_index :marcas, :contratante_id
  end
end
