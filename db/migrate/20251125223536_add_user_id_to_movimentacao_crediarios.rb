class AddUserIdToMovimentacaoCrediarios < ActiveRecord::Migration[8.0]
  def change
    add_reference :movimentacao_crediarios, :user, null: false, foreign_key: true
  end
end
