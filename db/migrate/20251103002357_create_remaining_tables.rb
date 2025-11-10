class CreateRemainingTables < ActiveRecord::Migration[8.0]
  def change
    # CLIENTE
    create_table :clientes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cli_cpf, null: false
      t.date :cli_data_nasc, null: false
      t.string :cli_estado_civil
      t.string :cli_endereco, null: false
      t.string :cli_telefone1, null: false
      t.string :cli_telefone2
      t.string :cli_email
      t.text :cli_observacao
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end
    add_index :clientes, :cli_cpf, unique: true

    # TAXA_CARTAO
    create_table :taxa_cartoes do |t|
      t.string :txc_tipo, null: false
      t.string :txc_descricao
      t.decimal :txc_porcentagem, precision: 5, scale: 2, null: false
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # PIX
    create_table :pixes do |t|
      t.string :pix_nome, null: false
      t.string :pix_chave, null: false
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # TAMANHO
    create_table :tamanhos do |t|
      t.string :tam_nome, null: false
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # TIPO
    create_table :tipos do |t|
      t.string :tip_nome, null: false
      t.string :tip_sigla
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # MARCA (recria se necessário)
    unless table_exists?(:marcas)
      create_table :marcas do |t|
        t.string :mar_nome, null: false
        t.string :mar_sigla
        t.references :contratante, null: false, foreign_key: true
        t.timestamps
      end
    end

    # PRODUTO
    create_table :produtos do |t|
      t.references :tipo, null: false, foreign_key: true
      t.references :marca, null: false, foreign_key: true
      t.references :tamanho, null: false, foreign_key: true
      t.string :pro_cor
      t.decimal :pro_valor_venda, precision: 10, scale: 2, null: false
      t.decimal :pro_valor_custo, precision: 10, scale: 2
      t.decimal :pro_quantidade, precision: 10, scale: 2, default: 0, null: false
      t.string :pro_status, default: 'Ativo'
      t.string :pro_status_estoque, default: 'em estoque'
      t.decimal :pro_estoque_minimo, precision: 10, scale: 2, default: 0
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # VENDA
    create_table :vendas do |t|
      t.datetime :ven_data, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.references :user, null: false, foreign_key: true # VEN_VENDEDOR
      t.decimal :ven_valor_total, precision: 10, scale: 2, null: false
      t.decimal :ven_valor_final, precision: 10, scale: 2, null: false
      t.decimal :ven_valor_real, precision: 10, scale: 2
      t.decimal :ven_desconto, precision: 10, scale: 2, default: 0
      t.string :ven_forma_pagamento
      t.references :cliente, foreign_key: true
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # VENDA_ITENS
    create_table :venda_itens do |t|
      t.references :venda, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.decimal :vei_quantidade, precision: 10, scale: 2, null: false
      t.decimal :vei_preco_unitario, precision: 10, scale: 2, null: false
      t.decimal :vei_subtotal, precision: 10, scale: 2
      t.timestamps
    end

    # ESTOQUE_MOVIMENTACAO
    create_table :estoque_movimentacoes do |t|
      t.references :produto, null: false, foreign_key: true
      t.datetime :emv_data, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.string :emv_tipo, null: false, limit: 1 # 'E' ou 'S'
      t.decimal :emv_quantidade, precision: 10, scale: 2, null: false
      t.decimal :emv_valor_unitario, precision: 10, scale: 2
      t.decimal :emv_valor_total, precision: 10, scale: 2
      t.string :emv_origem, null: false
      t.integer :emv_origem_id
      t.references :user, foreign_key: true
      t.text :emv_observacao
      t.references :contratante, null: false, foreign_key: true
      t.timestamps
    end

    # Adiciona índices para performance
    add_index :vendas, :ven_data
    add_index :estoque_movimentacoes, :emv_data
    add_index :estoque_movimentacoes, :emv_tipo
  end
end