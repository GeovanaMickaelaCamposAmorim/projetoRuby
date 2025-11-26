class SetDefaultTaxaCartoes < ActiveRecord::Migration[7.0]
  def change
    change_column_default :contratantes, :taxa_cartoes, 0
  end
end
