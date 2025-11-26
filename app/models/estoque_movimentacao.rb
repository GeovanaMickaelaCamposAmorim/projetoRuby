class EstoqueMovimentacao < ApplicationRecord
  self.table_name = "estoque_movimentacoes"
  belongs_to :produto
  belongs_to :user
  belongs_to :cliente, optional: true

  validates :produto_id, :quantidade, :emv_tipo, :user_id, presence: true
  validates :quantidade, numericality: { greater_than: 0 }

  # Tipos permitidos
  TIPOS = %w[reabastecimento retirada devolucao venda crediario]

  validates :emv_tipo, inclusion: { in: TIPOS }

  validate :retirada_nao_maior_que_estoque, if: -> { emv_tipo == "retirada" || emv_tipo == "venda" || emv_tipo == "crediario" }

  after_create :atualizar_estoque

  private

  def retirada_nao_maior_que_estoque
    if quantidade > produto.quantidade
      errors.add(:quantidade, "não pode ser maior que o estoque atual (#{produto.quantidade})")
    end
  end

  def atualizar_estoque
    case emv_tipo
    when "reabastecimento", "devolucao"
      produto.increment!(:quantidade, quantidade)
    when "retirada", "venda", "crediario"
      produto.decrement!(:quantidade, quantidade)
    end
  end
end
