class AddNomeAndDescricaoToProdutos < ActiveRecord::Migration[8.0]
  def change
    add_column :produtos, :pro_nome, :string
    add_column :produtos, :pro_descricao, :text
    add_column :produtos, :pro_codigo, :string
  end
end
