class Pix < ApplicationRecord
  belongs_to :contratante

  validates :pix_nome, :pix_chave, :contratante_id, presence: true
end