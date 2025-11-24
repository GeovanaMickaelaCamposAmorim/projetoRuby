class FichaCrediario < ApplicationRecord
  belongs_to :cliente
  belongs_to :contratante

  has_many :movimentacao_crediarios, dependent: :destroy

  # Sintaxe mais simples
  enum :fic_status, { pendente: "pendente", concluida: "concluida" }

  def saldo
    movimentacao_crediarios.sum(:mov_valor)
  end

  def atualizar_status!
    novo_saldo = saldo
    update!(
      fic_valor_total: novo_saldo,
      fic_status: novo_saldo > 0.00 ? :pendente : :concluida
    )
  end
end