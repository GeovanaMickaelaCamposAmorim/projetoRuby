# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_26_162639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clientes", force: :cascade do |t|
    t.string "cli_cpf", null: false
    t.date "cli_data_nasc", null: false
    t.string "cli_estado_civil"
    t.string "cli_endereco", null: false
    t.string "cli_telefone1", null: false
    t.string "cli_telefone2"
    t.string "cli_email"
    t.text "cli_observacao"
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cli_nome"
    t.string "status"
    t.index ["cli_cpf"], name: "index_clientes_on_cli_cpf", unique: true
    t.index ["contratante_id"], name: "index_clientes_on_contratante_id"
  end

  create_table "configuracaos", force: :cascade do |t|
    t.string "nome_loja"
    t.string "cnpj"
    t.string "telefone"
    t.string "endereco"
    t.string "instagram"
    t.string "cor_fundo_menu"
    t.string "cor_fonte_menu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contratantes", force: :cascade do |t|
    t.string "cnt_nome_loja", null: false
    t.string "cnt_cnpj", null: false
    t.string "cnt_cep", null: false
    t.string "cnt_telefone", null: false
    t.string "cnt_endereco", null: false
    t.string "cnt_instagram"
    t.string "cnt_nome_responsavel", null: false
    t.string "cnt_email_responsavel", null: false
    t.string "cnt_senha_responsavel", null: false
    t.string "cnt_telefone_responsavel", null: false
    t.string "cnt_status", default: "Ativo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "taxa_cartoes", default: "0.0"
    t.index ["cnt_cnpj"], name: "index_contratantes_on_cnt_cnpj", unique: true
  end

  create_table "estoque_movimentacaos", force: :cascade do |t|
    t.date "emv_data"
    t.string "emv_tipo"
    t.integer "emv_quantidade"
    t.decimal "emv_valor_total"
    t.bigint "produto_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_estoque_movimentacaos_on_produto_id"
  end

  create_table "estoque_movimentacoes", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.datetime "emv_data", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "emv_tipo", limit: 1, null: false
    t.decimal "emv_quantidade", precision: 10, scale: 2, null: false
    t.decimal "emv_valor_unitario", precision: 10, scale: 2
    t.decimal "emv_valor_total", precision: 10, scale: 2
    t.string "emv_origem", null: false
    t.integer "emv_origem_id"
    t.bigint "user_id"
    t.text "emv_observacao"
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cliente_id", null: false
    t.index ["cliente_id"], name: "index_estoque_movimentacoes_on_cliente_id"
    t.index ["contratante_id"], name: "index_estoque_movimentacoes_on_contratante_id"
    t.index ["emv_data"], name: "index_estoque_movimentacoes_on_emv_data"
    t.index ["emv_tipo"], name: "index_estoque_movimentacoes_on_emv_tipo"
    t.index ["produto_id"], name: "index_estoque_movimentacoes_on_produto_id"
    t.index ["user_id"], name: "index_estoque_movimentacoes_on_user_id"
  end

  create_table "ficha_crediarios", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.bigint "contratante_id", null: false
    t.decimal "fic_valor_total", precision: 10, scale: 2, default: "0.0"
    t.string "fic_status", default: "pendente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_ficha_crediarios_on_cliente_id"
    t.index ["contratante_id"], name: "index_ficha_crediarios_on_contratante_id"
  end

  create_table "gastos", force: :cascade do |t|
    t.datetime "gas_data", null: false
    t.string "gas_descricao", null: false
    t.decimal "gas_valor", precision: 10, scale: 2, null: false
    t.bigint "user_id", null: false
    t.bigint "contratante_id", null: false
    t.datetime "gas_data_cadastro", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contratante_id"], name: "index_gastos_on_contratante_id"
    t.index ["gas_data"], name: "index_gastos_on_gas_data"
    t.index ["user_id"], name: "index_gastos_on_user_id"
  end

  create_table "label_configs", force: :cascade do |t|
    t.string "name"
    t.string "color", default: "#4E4E4E"
    t.boolean "is_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lojas", force: :cascade do |t|
    t.string "loj_nome", null: false
    t.string "loj_cnpj", null: false
    t.string "loj_telefone", null: false
    t.string "loj_cep", null: false
    t.string "loj_endereco", null: false
    t.string "loj_instagram"
    t.binary "loj_logo"
    t.string "loj_cor_fundo"
    t.string "loj_cor_fonte"
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contratante_id"], name: "index_lojas_on_contratante_id"
    t.index ["contratante_id"], name: "unique_loja_contratante", unique: true
  end

  create_table "marcas", force: :cascade do |t|
    t.string "nome"
    t.text "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "contratante_id"
    t.index ["contratante_id"], name: "index_marcas_on_contratante_id"
  end

  create_table "movimentacao_crediarios", force: :cascade do |t|
    t.bigint "ficha_crediario_id", null: false
    t.string "mov_tipo"
    t.decimal "mov_valor", precision: 10, scale: 2, default: "0.0"
    t.text "mov_observacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "mov_valor_real"
    t.index ["ficha_crediario_id"], name: "index_movimentacao_crediarios_on_ficha_crediario_id"
    t.index ["user_id"], name: "index_movimentacao_crediarios_on_user_id"
  end

  create_table "pixes", force: :cascade do |t|
    t.string "pix_nome", null: false
    t.string "pix_chave", null: false
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contratante_id"], name: "index_pixes_on_contratante_id"
  end

  create_table "produtos", force: :cascade do |t|
    t.bigint "tipo_id", null: false
    t.bigint "marca_id", null: false
    t.bigint "tamanho_id", null: false
    t.string "pro_cor"
    t.decimal "pro_valor_venda", precision: 10, scale: 2, null: false
    t.decimal "pro_valor_custo", precision: 10, scale: 2
    t.integer "pro_quantidade", default: 0, null: false
    t.string "pro_status", default: "Ativo"
    t.string "pro_status_estoque", default: "em estoque"
    t.integer "pro_estoque_minimo", default: 0
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pro_nome"
    t.text "pro_descricao"
    t.string "pro_codigo"
    t.decimal "pro_valor_promo", precision: 10, scale: 2
    t.index ["contratante_id"], name: "index_produtos_on_contratante_id"
    t.index ["marca_id"], name: "index_produtos_on_marca_id"
    t.index ["tamanho_id"], name: "index_produtos_on_tamanho_id"
    t.index ["tipo_id"], name: "index_produtos_on_tipo_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tag_templates", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.string "store_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "label_config_id"
    t.index ["label_config_id"], name: "index_tag_templates_on_label_config_id"
  end

  create_table "tamanhos", force: :cascade do |t|
    t.string "tam_nome", null: false
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contratante_id"], name: "index_tamanhos_on_contratante_id"
  end

  create_table "taxa_cartoes", force: :cascade do |t|
    t.string "txc_tipo", null: false
    t.string "txc_descricao"
    t.decimal "txc_porcentagem", precision: 5, scale: 2, null: false
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contratante_id"], name: "index_taxa_cartoes_on_contratante_id"
  end

  create_table "tipos", force: :cascade do |t|
    t.string "tip_nome", null: false
    t.string "tip_sigla"
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contratante_id"], name: "index_tipos_on_contratante_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "usu_email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "usu_tipo"
    t.string "usu_nome", null: false
    t.string "usu_telefone", null: false
    t.string "usu_status", default: "Ativo"
    t.bigint "contratante_id"
    t.index ["contratante_id"], name: "index_users_on_contratante_id"
    t.index ["usu_email"], name: "index_users_on_usu_email", unique: true
  end

  create_table "venda_itens", force: :cascade do |t|
    t.bigint "venda_id", null: false
    t.bigint "produto_id", null: false
    t.decimal "vei_quantidade", precision: 10, scale: 2, null: false
    t.decimal "vei_preco_unitario", precision: 10, scale: 2, null: false
    t.decimal "vei_subtotal", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_venda_itens_on_produto_id"
    t.index ["venda_id"], name: "index_venda_itens_on_venda_id"
  end

  create_table "vendas", force: :cascade do |t|
    t.datetime "ven_data", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "user_id", null: false
    t.decimal "ven_valor_total", precision: 10, scale: 2, null: false
    t.decimal "ven_valor_final", precision: 10, scale: 2, null: false
    t.decimal "ven_valor_real", precision: 10, scale: 2
    t.decimal "ven_desconto", precision: 10, scale: 2, default: "0.0"
    t.string "ven_forma_pagamento"
    t.bigint "cliente_id"
    t.bigint "contratante_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_vendas_on_cliente_id"
    t.index ["contratante_id"], name: "index_vendas_on_contratante_id"
    t.index ["user_id"], name: "index_vendas_on_user_id"
    t.index ["ven_data"], name: "index_vendas_on_ven_data"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clientes", "contratantes"
  add_foreign_key "estoque_movimentacaos", "produtos"
  add_foreign_key "estoque_movimentacoes", "clientes"
  add_foreign_key "estoque_movimentacoes", "contratantes"
  add_foreign_key "estoque_movimentacoes", "produtos"
  add_foreign_key "estoque_movimentacoes", "users"
  add_foreign_key "ficha_crediarios", "clientes"
  add_foreign_key "ficha_crediarios", "contratantes"
  add_foreign_key "gastos", "contratantes"
  add_foreign_key "gastos", "users"
  add_foreign_key "lojas", "contratantes"
  add_foreign_key "movimentacao_crediarios", "ficha_crediarios"
  add_foreign_key "movimentacao_crediarios", "users"
  add_foreign_key "pixes", "contratantes"
  add_foreign_key "produtos", "contratantes"
  add_foreign_key "produtos", "marcas"
  add_foreign_key "produtos", "tamanhos"
  add_foreign_key "produtos", "tipos"
  add_foreign_key "sessions", "users"
  add_foreign_key "tag_templates", "label_configs"
  add_foreign_key "tamanhos", "contratantes"
  add_foreign_key "taxa_cartoes", "contratantes"
  add_foreign_key "tipos", "contratantes"
  add_foreign_key "user_sessions", "users"
  add_foreign_key "users", "contratantes"
  add_foreign_key "venda_itens", "produtos"
  add_foreign_key "venda_itens", "vendas"
  add_foreign_key "vendas", "clientes"
  add_foreign_key "vendas", "contratantes"
  add_foreign_key "vendas", "users"
end
