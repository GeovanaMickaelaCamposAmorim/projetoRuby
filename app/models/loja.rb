class Loja < ApplicationRecord
  belongs_to :contratante
  has_one_attached :loj_logo

  validates :loj_nome, :loj_cnpj, :loj_telefone, :loj_cep, 
            :loj_endereco, :contratante_id, presence: true

  # Validação opcional para formato do CNPJ
  validates :loj_cnpj, format: { with: /\A\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}\z/, message: "formato inválido" }, allow_blank: true
end