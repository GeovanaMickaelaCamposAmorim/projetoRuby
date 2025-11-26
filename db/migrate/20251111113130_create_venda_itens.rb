class CreateVendaItens < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:venda_itens)
      create_table :venda_itens do |t|
        t.references :venda, null: false, foreign_key: true
        t.references :produto, null: false, foreign_key: true
        t.decimal :vei_quantidade, precision: 10, scale: 2, null: false
        t.decimal :vei_preco_unitario, precision: 10, scale: 2, null: false
        t.decimal :vei_subtotal, precision: 10, scale: 2

        t.timestamps
      end
    end
  end
end
