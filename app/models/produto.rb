class Produto < ApplicationRecord
  belongs_to :tipo
  belongs_to :marca
  belongs_to :tamanho
  belongs_to :contratante
  has_many :venda_itens
  has_many :estoque_movimentacoes

  validates :pro_valor_venda, :pro_quantidade, :tipo_id, :marca_id, 
            :tamanho_id, :contratante_id, presence: true
  validates :pro_valor_venda, numericality: { greater_than: 0 }
  validates :pro_quantidade, numericality: { greater_than_or_equal_to: 0 }
   validates :pro_valor_promo, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def valor_atual
    pro_valor_promo.present? && pro_valor_promo > 0 ? pro_valor_promo : pro_valor_venda
  end

  def em_promocao?
    pro_valor_promo.present? && pro_valor_promo > 0
  end
  
end