json.extract! estoque_movimentacao, :id, :emv_data, :emv_tipo, :emv_quantidade, :emv_valor_total, :produto_id, :created_at, :updated_at
json.url estoque_movimentacao_url(estoque_movimentacao, format: :json)
