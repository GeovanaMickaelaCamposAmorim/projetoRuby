class SetupBusinessTables < ActiveRecord::Migration[8.0]
  def change
    # LOJA
    unless table_exists?(:lojas)
      create_table :lojas do |t|
        t.string :loj_nome, null: false
        t.string :loj_cnpj, null: false
        t.string :loj_telefone, null: false
        t.string :loj_cep, null: false
        t.string :loj_endereco, null: false
        t.string :loj_instagram
        t.binary :loj_logo
        t.string :loj_cor_fundo
        t.string :loj_cor_fonte
        t.references :contratante, null: false, foreign_key: true
        t.timestamps
      end

      add_index :lojas, :contratante_id, unique: true, name: "unique_loja_contratante"
    end

    # CAMPOS PARA USERS
    unless column_exists?(:users, :usu_nome)
      add_column :users, :usu_nome, :string
      add_column :users, :usu_telefone, :string
      add_column :users, :usu_status, :string, default: "Ativo"
      add_reference :users, :contratante, foreign_key: true

      # Atualiza valores via SQL (não usa model)
      execute <<~SQL
        UPDATE users
        SET usu_nome = 'Usuário'
        WHERE usu_nome IS NULL;
      SQL

      execute <<~SQL
        UPDATE users
        SET usu_telefone = '000000000'
        WHERE usu_telefone IS NULL;
      SQL

      change_column_null :users, :usu_nome, false
      change_column_null :users, :usu_telefone, false
    end

    # RENOMEAÇÃO DE COLUNAS
    if column_exists?(:users, :email_address)
      rename_column :users, :email_address, :usu_email
    end

    if column_exists?(:users, :role)
      rename_column :users, :role, :usu_tipo
    end
  end
end
