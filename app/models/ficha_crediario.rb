class FichaCrediario < ApplicationRecord
  belongs_to :cliente
  belongs_to :contratante

  has_many :movimentacao_crediarios, dependent: :destroy

  enum :fic_status, { pendente: "pendente", concluida: "concluida" }
  validates :fic_status, inclusion: { in: fic_statuses.keys }

  # Saldo base + movimentações
  def saldo_real
    movimentacao_crediarios.inject(fic_valor_total) do |total, mov|
      case mov.mov_tipo
      when "pagamento"
        total - mov.mov_valor_real
      when "juros", "compra"
        total + mov.mov_valor
      when "devolucao"
        total - mov.mov_valor
      else
        total
      end
    end
  end

  # Atualiza status com base no saldo real
  def atualizar_status!
    update!(fic_status: saldo_real > 0 ? :pendente : :concluida)
  end
end
