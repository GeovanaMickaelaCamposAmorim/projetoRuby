json.extract! movimentacao_crediario, :id, :ficha_crediario_id, :mov_tipo, :mov_valor, :mov_observacao, :created_at, :updated_at
json.url movimentacao_crediario_url(movimentacao_crediario, format: :json)
