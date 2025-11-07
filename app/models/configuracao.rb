class Configuracao < ApplicationRecord
  has_one_attached :logo

  # validates :nome_loja, presence: true
end
