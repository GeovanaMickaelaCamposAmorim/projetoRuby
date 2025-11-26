class MovimentacaoCrediario < ApplicationRecord
  belongs_to :ficha_crediario
  belongs_to :user

  enum :mov_tipo, { pagamento: "pagamento", juros: "juros", compra: "compra", devolucao: "devolucao" }

  validates :mov_valor, presence: true
  validates :mov_tipo, presence: true
end
