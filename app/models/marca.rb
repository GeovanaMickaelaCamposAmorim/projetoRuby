class Marca < ApplicationRecord
  # A tabela marcas tem colunas diferentes do esperado
  # nome e descricao em vez de mar_nome e mar_sigla
  
  validates :nome, presence: true
end