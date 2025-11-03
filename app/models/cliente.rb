class Cliente < ApplicationRecord
  belongs_to :user
  belongs_to :contratante

  validates :cli_cpf, :cli_data_nasc, :cli_endereco, :cli_telefone1, 
            :user_id, :contratante_id, presence: true
  validates :cli_cpf, uniqueness: true
end