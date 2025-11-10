class CreateConfiguracaos < ActiveRecord::Migration[8.0]
  def change
    create_table :configuracaos do |t|
      t.string :nome_loja
      t.string :cnpj
      t.string :telefone
      t.string :endereco
      t.string :instagram
      t.string :cor_fundo_menu
      t.string :cor_fonte_menu

      t.timestamps
    end
  end
end
