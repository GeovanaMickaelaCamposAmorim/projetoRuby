class TaxaCartao < ApplicationRecord
  belongs_to :contratante

  validates :txc_tipo, :txc_porcentagem, :contratante_id, presence: true
end