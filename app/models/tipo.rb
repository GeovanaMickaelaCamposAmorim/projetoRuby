class Tipo < ApplicationRecord
  belongs_to :contratante
  has_many :produtos

  validates :tip_nome, :contratante_id, presence: true
end