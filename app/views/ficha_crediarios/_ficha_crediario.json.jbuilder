json.extract! ficha_crediario, :id, :cliente_id, :contratante_id, :fic_valor_total, :fic_status, :created_at, :updated_at
json.url ficha_crediario_url(ficha_crediario, format: :json)
