class MovimentacaoCrediario < ApplicationRecord
  belongs_to :ficha_crediario
  belongs_to :user

  enum :mov_tipo, { pagamento: "pagamento", juros: "juros", compra: "compra", devolucao: "devolucao" }

  validates :mov_valor, presence: true
  validates :mov_tipo, presence: true

  before_save :calcular_valor_real

  private

  def calcular_valor_real
    if mov_tipo == "pagamento"
      taxa = ficha_crediario.contratante.taxa_cartoes.to_f
      self.mov_valor_real = mov_valor - (mov_valor * taxa / 100.0)
    else
      self.mov_valor_real = mov_valor
    end
  end
end
