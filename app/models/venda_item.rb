class VendaItem < ApplicationRecord
  self.table_name = 'venda_itens'  
  
  belongs_to :venda
  belongs_to :produto

  validates :vei_quantidade, :vei_preco_unitario, presence: true
  validates :vei_quantidade, numericality: { greater_than: 0 }

  before_save :calcular_subtotal

  private

  def calcular_subtotal
    self.vei_subtotal = vei_quantidade * vei_preco_unitario
  end
end