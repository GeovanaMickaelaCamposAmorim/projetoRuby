class Tamanho < ApplicationRecord
  belongs_to :contratante
  has_many :produtos

  validates :tam_nome, :contratante_id, presence: true
end