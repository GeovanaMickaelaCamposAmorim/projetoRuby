class EstoqueMovimentacao < ApplicationRecord
  belongs_to :produto
  belongs_to :user, optional: true
  belongs_to :contratante

  validates :emv_tipo, :emv_quantidade, :emv_origem, :produto_id, :contratante_id, presence: true
  validates :emv_tipo, inclusion: { in: ['E', 'S'] }
  validates :emv_quantidade, numericality: { greater_than: 0 }
end