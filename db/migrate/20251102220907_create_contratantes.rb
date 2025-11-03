class CreateContratantes < ActiveRecord::Migration[8.0]
  def change
    create_table :contratantes do |t|
      t.string :cnt_nome_loja, null: false
      t.string :cnt_cnpj, null: false
      t.string :cnt_cep, null: false
      t.string :cnt_telefone, null: false
      t.string :cnt_endereco, null: false
      t.string :cnt_instagram
      t.string :cnt_nome_responsavel, null: false
      t.string :cnt_email_responsavel, null: false
      t.string :cnt_senha_responsavel, null: false
      t.string :cnt_telefone_responsavel, null: false
      t.string :cnt_status, default: 'Ativo'

      t.timestamps
    end

    add_index :contratantes, :cnt_cnpj, unique: true
  end
end