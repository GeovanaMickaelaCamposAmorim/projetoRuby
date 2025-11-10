class AddStatusToClientes < ActiveRecord::Migration[8.0]
  def change
    add_column :clientes, :status, :string
  end
end
