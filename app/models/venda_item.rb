class VendaItem < ApplicationRecord
  belongs_to :venda
  belongs_to :produto

  validates :vei_quantidade, :vei_preco_unitario, presence: true
  validates :vei_quantidade, numericality: { greater_than: 0 }
end