class DropVendaItems < ActiveRecord::Migration[8.0]
  def change
    drop_table :venda_items, if_exists: true
  end
end
