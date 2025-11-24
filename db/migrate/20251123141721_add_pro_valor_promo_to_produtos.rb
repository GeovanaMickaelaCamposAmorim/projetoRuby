class AddProValorPromoToProdutos < ActiveRecord::Migration[7.0]
  def change
    add_column :produtos, :pro_valor_promo, :decimal, precision: 10, scale: 2
  end
end