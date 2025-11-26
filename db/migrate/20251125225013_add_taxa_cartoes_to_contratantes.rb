class AddTaxaCartoesToContratantes < ActiveRecord::Migration[8.0]
  def change
    add_column :contratantes, :taxa_cartoes, :decimal
  end
end
