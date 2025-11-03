class Loja < ApplicationRecord
  belongs_to :contratante

  validates :loj_nome, :loj_cnpj, :loj_telefone, :loj_cep, 
            :loj_endereco, :contratante_id, presence: true

has_one_attached :loj_logo
end