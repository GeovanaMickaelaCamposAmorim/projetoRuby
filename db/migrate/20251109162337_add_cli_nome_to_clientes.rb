class AddCliNomeToClientes < ActiveRecord::Migration[8.0]
  def change
    add_column :clientes, :cli_nome, :string
  end
end
