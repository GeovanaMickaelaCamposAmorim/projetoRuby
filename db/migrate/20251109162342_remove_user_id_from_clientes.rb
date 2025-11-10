class RemoveUserIdFromClientes < ActiveRecord::Migration[8.0]
  def change
    remove_column :clientes, :user_id, :bigint
  end
end
